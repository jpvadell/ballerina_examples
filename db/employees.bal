import ballerina.data.sql;
import ballerina.lang.messages;
import ballerina.lang.datatables;
import ballerina.lang.jsons;
import ballerina.lang.exceptions;
import ballerina.lang.strings;
@http:BasePath("/employees")
service Employees {
	string dbURL = "jdbc:oracle:thin:@localhost:49161/XE";
	string username = "vatrox";
	string password = "vatrox";
	map propertiesMap = {"jdbcUrl":dbURL, "username":username, "password":password
	}
	;
	sql:ClientConnector lcDBConnector = create sql:ClientConnector(propertiesMap);
	
	@http:GET
	@http:Path("/")
	resource select(message m) {
		sql:Parameter[] params = [];
		try {
			datatable dt = sql:ClientConnector.select(lcDBConnector, "select empno,ename,job,mgr,hiredate,sal,comm,deptno from emp", params);
			json payload = datatables:toJson(dt);
			message response = {};
			messages:setJsonPayload(response, payload);
			reply response;
			
		}
		catch (exception e) {
            message response = {};
			messages:setJsonPayload(response, responseException("select",e));
			reply response;
			
		}
		
	}
	
	@http:POST
	@http:Path("/")
	resource insert(message m) {
		sql:Parameter[] params = [];
		json jsonRequest = messages:getJsonPayload(m);
		params[0] = {sqlType:"NUMERIC", value:strings:valueOf(jsons:getInt(jsonRequest, "$.EMPNO")), direction:0
		}
		;
		params[1] = {sqlType:"VARCHAR", value:jsons:getString(jsonRequest, "$.ENAME"), direction:0
		}
		;
		params[2] = {sqlType:"VARCHAR", value:jsons:getString(jsonRequest, "$.JOB"), direction:0
		}
		;
		params[3] = {sqlType:"NUMERIC", value:strings:valueOf(jsons:getInt(jsonRequest, "$.MGR")), direction:0
		}
		;
		params[4] = {sqlType:"VARCHAR", value:jsons:getString(jsonRequest, "$.HIREDATE"), direction:0
		}
		;
		params[5] = {sqlType:"NUMERIC", value:strings:valueOf(jsons:getInt(jsonRequest, "$.SAL")), direction:0
		}
		;
		params[6] = {sqlType:"NUMERIC", value:strings:valueOf(jsons:getInt(jsonRequest, "$.COMM")), direction:0
		}
		;
		params[7] = {sqlType:"NUMERIC", value:strings:valueOf(jsons:getInt(jsonRequest, "$.DEPTNO")), direction:0
		}
		;
		try {
			int insertCode = sql:ClientConnector.update(lcDBConnector, "insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno) values (?,?,?,?,to_date(?,'DD/MM/YYYY'),?,?,?)", params);
			string insertResponse = "OK";
			if (insertCode == 0) {
				insertResponse = "Not found";
				
			}
			else {
				}json payload = `{"insert":${insertResponse}}`;
			message response = {};
			messages:setJsonPayload(response, payload);
			reply response;
			
		}
		catch (exception e) {
            message response = {};
			messages:setJsonPayload(response, responseException("insert",e));
			reply response;
		}
		
	}
	
	@http:DELETE
	@http:Path("/{id}")
	resource delete(message m, 
	@http:PathParam("id")string empno) {
		sql:Parameter[] params = [];
		params[0] = {sqlType:"NUMERIC", value:empno, direction:0
		}
		;
		try {
			int deleteCode = sql:ClientConnector.update(lcDBConnector, "delete from emp where empno = ?", params);
			string deleteResponse = "OK";
			if (deleteCode == 0) {
				deleteResponse = "Not found";
				
			}
			else {
				}
			json payload = `{"delete":${deleteResponse}}`;
			message response = {};
			messages:setJsonPayload(response, payload);
			reply response;
			
		}
		catch (exception e) {
            message response = {};
			messages:setJsonPayload(response, responseException("delete",e));
			reply response;
			
		}
		
	}
	
}
function responseException(string resourceName,exception e) (json) {
    		string errorMessage = strings:trim(exceptions:getMessage(e));
			json payload = `{${resourceName}:${errorMessage}}`;
			return payload;
	}
