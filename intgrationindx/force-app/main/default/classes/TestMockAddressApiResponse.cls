@istest
global class TestMockAddressApiResponse implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody('{"results":[{"address_components":[{"long_name":"1919","short_name":"1919","types":["street_number"]},{"long_name":"North Lynn Street","short_name":"N Lynn St","types":["route"]},{"long_name":"Arlington","short_name":"Arlington","types":["locality","political"]},{"long_name":"Arlington County","short_name":"Arlington County","types":["administrative_area_level_2","political"]},{"long_name":"Virginia","short_name":"VA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"22209","short_name":"22209","types":["postal_code"]},{"long_name":"1742","short_name":"1742","types":["postal_code_suffix"]}],"formatted_address":"1919 N Lynn St, Arlington, VA 22209, USA","geometry":{"bounds":{"northeast":{"lat":38.8979506,"lng":-77.0699271},"southwest":{"lat":38.8974339,"lng":-77.0707383}},"location":{"lat":38.8976978,"lng":-77.0703873},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":38.8990412302915,"lng":-77.06902271970849},"southwest":{"lat":38.8963432697085,"lng":-77.07172068029149}}},"partial_match":true,"place_id":"ChIJr_KJ-1q2t4kRXvXox-w-F_4","types":["premise"]}],"status":"OK"}');
        res.setStatusCode(200);
        return res;
        
    }
}