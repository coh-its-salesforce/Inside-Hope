@isTest
global class MockArmisAPICall implements HttpCalloutMock {
    public MockArmisAPICall() {}

    global HTTPResponse respond(HTTPRequest req) {
        String url = req.getEndpoint();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (url.containsIgnoreCase('access_token'))
        {
            System.assertEquals('POST', req.getMethod());
            res.setBody('{"data": {"access_token": "This will be your access token","expiration_utc": "2019-06-06T20:43:58.758533" },"success": true}');
            res.setStatusCode(201);
        }
        else if (url.containsIgnoreCase('search'))
        {
            System.assertEquals('GET', req.getMethod());
            res.setBody('{"data":{"count": 4, "data":[{"category": "Medical Therapeutic", "firstSeen": "2019-01-29T18:33:05.366949","id": 20, "ipAddress": "10.139.29.144","lastSeen": "2019-09-12T18:40:43.868254","macAddress": "00:17:23:24:c9:ea","manufacturer": "Becton Dickinson","model": "Alaris PCU", "name": null, "operatingSystem": "Enea OSE", "operatingSystemVersion": null,"riskLevel": 1,"tags": [ "Corporate", "VxWorks","VxWorks-5.5"],"type": "Acute Care", "user": ""},{"category":"Medical","firstSeen":"2019-03-18T16:49:08.786975","id":400,"ipAddress":"172.16.14.51","lastSeen":"2019-04-03T22:11:31.064383","macAddress":"c4:b8:ed:00:00:00","manufacturer":"Siemens","model":"MRI Machine","name":"MRI Machine","operatingSystem": "Windows", "operatingSystemVersion": null, "riskLevel": 5,"tags": [ "MRI Scanner", "FDA-Certified", "Medical Network" ],"type": "Diagnostic", "user": null}, {"category": "Medical Therapeutic", "firstSeen": "2019-01-29T18:33:05.366949","id": 73, "ipAddress": "10.139.29.144","lastSeen": "2019-09-12T18:40:43.868254","macAddress": "00:17:23:24:c9:ea","manufacturer": "Becton Dickinson","model": "Alaris PCU", "name": null, "operatingSystem": "Enea OSE", "operatingSystemVersion": null,"riskLevel": 9,"tags": [ "Corporate", "VxWorks","VxWorks-5.5"],"type": "Acute Care", "user": ""}],"next": 0,"prev": 0,"total": 4},"success": true}');
            res.setStatusCode(200);
        }

        return res;
    }
}