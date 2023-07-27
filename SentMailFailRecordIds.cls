global class SentMailFailRecordIds implements Database.Batchable<SObject>, Database.Stateful {
    global List<Id> failureRecordIds = new List<Id>(); // To store failure record IDs
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Description, NumberOfEmployees, (SELECT Id, LastName FROM Contacts) FROM Account limit 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        System.debug('Current Records is => '+scope.size());
        
        List<Account> accountsToUpdate = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Account acc : scope) {
            // Update Account fields
            acc.Description = 'this description is the update';
            acc.NumberOfEmployees = 15;
            accountsToUpdate.add(acc);
            
            // Update related Contact fields
            for (Contact con : acc.Contacts) {
                con.LastName = 'updateBatchClass';
                contactsToUpdate.add(con);
            }
        }
        
        // Perform DML operations to update the records
        Database.SaveResult[] accountUpdateResults = Database.update(accountsToUpdate, false);
        Database.SaveResult[] contactUpdateResults = Database.update(contactsToUpdate, false);
        System.debug('Account update record is: '+accountsToUpdate);
        System.debug('Contact Update record is: '+contactsToUpdate);
        
        // Collect the failure record IDs
        for (Database.SaveResult sr : accountUpdateResults) {
            if (!sr.isSuccess()) {
                failureRecordIds.add(sr.getId());
            }
        }
        for (Database.SaveResult sr : contactUpdateResults) {
            if (!sr.isSuccess()) {
                failureRecordIds.add(sr.getId());
            }
        }
    }
   
    global void finish(Database.BatchableContext BC) {
        System.debug('Within a finish method');
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'yogendra.s@hicglobalsolutions.com'});
        email.setSubject('Deleted Account Alert');
        email.setPlainTextBody('Failure records of ids is: '+failureRecordIds);
        emails.add(email);
        Messaging.sendEmail(emails);
        System.debug('Email is sent: ');
    }
}