@isTEst
public class physicianListTest {

    testmethod static void main(){
        List<physicianList> recordList =new List<physicianList>();
        physicianList record = new physicianList(0,'test',null);
        physicianList record1 = new physicianList(1,'test',null);
        recordList.add(record);
        recordList.add(record1);
        recordList.sort();
    }
}