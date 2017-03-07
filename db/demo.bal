import ballerina.lang.messages;
import ballerina.lang.system;

function main(string[] args) {
        system:println(args[0]);
        message m = {}; 
        messages:setStringPayload(m,args[0]);
        fork (m){
            worker uno (message m) {
                json payload = `{"resultado":"1"}`;            
                message response = {};
                messages:setJsonPayload(response, payload);
		        reply response;
            }

            worker dos (message m) {
                json payload = `{"resultado":"2"}`;
                message response = {};
                messages:setJsonPayload(response, payload);
		        reply response;
            }
        } join (all) (message[] forkResponse) {
            system:println(messages:getJsonPayload(forkResponse[0]));
            system:println(messages:getJsonPayload(forkResponse[1]));
        }

}
