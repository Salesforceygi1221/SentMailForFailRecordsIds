@isTest
public class UtilityForTestSentMailFailRecordIds {
    public static void insertAccConForTest(Integer numAcc, Integer numConRelAcc){
        List<Account> accountlist = new List<Account>();
        List<Contact> contactlist = new List<Contact>();
        for(Integer i = 1; i<=numAcc; i++){
            //insert dummy account
            Account acc = new Account(Name = 'test'+i,
                                     Description = 'New Description updated by batch class',
                                     NumberOfEmployees = 12);
			
            //insert dummy contacts per account
            for(Integer j = 1; j<=numConRelAcc; j++){
                Contact con = new Contact(AccountId = acc.Id,
                                         LastName = 'lastname'+j);
                contactlist.add(con);
            }
            accountlist.add(acc);
        }
        insert accountlist;
        insert contactlist;
    }
}