public class LockRecordRequest {
    @InvocableMethod(label='Lock Record Request' description='Lock Provided Record')
    public static void LockRecordList(List<id> recordIds)
    {
            Approval.Lock(recordIds);   
    }
}