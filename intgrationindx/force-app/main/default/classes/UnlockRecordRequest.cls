public class UnlockRecordRequest {
    @InvocableMethod(label='Unlock  Record Request' description='Unlock Provided Record')
    public static void unlockRecordList(List<id> recordIds)
    {
            Approval.Unlock(recordIds);   
    }
}