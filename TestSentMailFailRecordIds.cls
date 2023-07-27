@isTest
public class TestSentMailFailRecordIds {
    @isTest static void testSentMailFailureRecordIds(){
        //call utility class for dummy data
        UtilityForTestSentMailFailRecordIds.insertAccConForTest(200,3);
        
        //test batch apex
        test.startTest();
        	SentMailFailRecordIds smfri = new SentMailFailRecordIds();
            database.executeBatch(smfri, 200);
        test.stopTest();
    }
}