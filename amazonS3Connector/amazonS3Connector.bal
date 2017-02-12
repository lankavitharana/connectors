package samples.connectors.sample;

import ballerina.lang.system;
import ballerina.lang.message;
import ballerina.lang.string;
import ballerina.net.http;
import ballerina.net.uri;
import ballerina.util;



connector AmazonS3(string accessKeyId, string secretAccessKey,
                string region, string serviceName, string terminationString) {

    AmazonAuthConnector amazonAuthConnector = create AmazonAuthConnector("AKIAIJ2IBQUCKKAL72IA", "AeUD3+Ic9BWH6ZEq+3K7zhxJ/zjzXkuicA883dPd", "us-east-1", "s3", "aws4_request", "https://s3.us-east-1.amazonaws.com");

	action getBucketList(AmazonS3 s3Connector) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "GET";
            requestURI = "/";
            host = "s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

	action getObjectList(AmazonS3 s3Connector, string bucketName) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "GET";
            requestURI = "/";
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

	action createBucket(AmazonS3 s3Connector, string bucketName) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "PUT";
            requestURI = "/";
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

	action deleteBucket(AmazonS3 s3Connector, string bucketName) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "DELETE";
            requestURI = "/";
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

	action getObject(AmazonS3 s3Connector, string bucketName, string objectName) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "GET";
            requestURI = "/" + objectName;
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}


	action deleteObject(AmazonS3 s3Connector, string bucketName, string objectName) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "DELETE";
            requestURI = "/" + objectName;
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";

            message:setHeader(requestMsg, "Host", host);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

	action putObject(AmazonS3 s3Connector, string bucketName, string objectName, string payload) (message) throws exception {

            string signature;
            string httpMethod;
            string requestURI;
            string host;
            string endpoint;
            message requestMsg = {};
            message response;

            httpMethod = "PUT";
            requestURI = "/" + objectName;
            host = bucketName + ".s3.amazonaws.com:443";
            endpoint = "https://s3." + region + ".amazonaws.com";
	    message:setStringPayload(requestMsg, payload);
	    message:setHeader(requestMsg, "X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");

            message:setHeader(requestMsg, "Host", host);
            response = AmazonAuthConnector.req(amazonAuthConnector, requestMsg, httpMethod, requestURI, "");

            return response;
    	}

}



connector AmazonAuthConnector(string accessKeyId, string secretAccessKey,
                string region, string serviceName, string terminationString, string endpoint) {
    http:ClientConnector awsEP = create http:ClientConnector("https://test32512233.s3.amazonaws.com:443");

    action req(AmazonAuthConnector amazonAuthConnector, message requestMsg, string httpMethod, string requestURI, string payload) (message) throws exception {

        message response;

        requestMsg = generateSignature(requestMsg, accessKeyId, secretAccessKey, region, serviceName, terminationString, httpMethod, requestURI, "");

        if(string:equalsIgnoreCase(httpMethod,"POST")){
            response = http:ClientConnector.post(awsEP, requestURI, requestMsg);
        }else if(string:equalsIgnoreCase(httpMethod,"GET")){
            response = http:ClientConnector.get(awsEP, requestURI, requestMsg);
        }else if(string:equalsIgnoreCase(httpMethod,"PUT")){
            response = http:ClientConnector.put(awsEP, requestURI, requestMsg);
        }else if(string:equalsIgnoreCase(httpMethod,"DELETE")){
            response = http:ClientConnector.delete(awsEP, requestURI, requestMsg);
        }

        return response;

    }

}



function generateSignature(message msg, string accessKeyId, string secretAccessKey, string region, string serviceName, string terminationString, string httpMethod, string requestURI, string payload) (message) throws exception {

    string canonicalRequest;
    string canonicalQueryString;
    string stringToSign;
    string payloadBuilder;
    string payloadStrBuilder;
    string authHeader;
    string algorithm;
    string amzDate;
    string shortDate;


    string signedHeader;
    string canonicalHeaders;

    string signedHeaders;
    string requestPayload;

    string signingKey;

    algorithm = "SHA256";



    amzDate = system:getDateFormat("yyyyMMdd'T'HHmmss'Z'");
    shortDate = system:getDateFormat("yyyyMMdd");

    message:setHeader(msg, "X-Amz-Date", amzDate);
    message:setHeader(msg, "Content-Type", "text/plain");



    canonicalRequest = httpMethod;
    canonicalRequest = canonicalRequest + "\n";

    canonicalRequest = canonicalRequest + string:replaceAll(uri:encode(requestURI), "%2F", "/");
    canonicalRequest = canonicalRequest + "\n";

    canonicalQueryString = "";

    canonicalRequest = canonicalRequest + canonicalQueryString;
    canonicalRequest = canonicalRequest + "\n";



    if(payload != ""){

            canonicalHeaders = canonicalHeaders + string:toLowerCase("Content-Type");
            canonicalHeaders = canonicalHeaders + ":";
            canonicalHeaders = canonicalHeaders + (message:getHeader(msg, string:toLowerCase("Content-Type")));
            canonicalHeaders = canonicalHeaders + "\n";
            signedHeader = signedHeader + string:toLowerCase("Content-Type");
            signedHeader = signedHeader + ";";
    }

    canonicalHeaders = canonicalHeaders + string:toLowerCase("Host");
    canonicalHeaders = canonicalHeaders + ":";
    canonicalHeaders = canonicalHeaders + message:getHeader(msg, string:toLowerCase("Host"));
    canonicalHeaders = canonicalHeaders + "\n";
    signedHeader = signedHeader + string:toLowerCase("Host");
    signedHeader = signedHeader + ";";

    canonicalHeaders = canonicalHeaders + string:toLowerCase("X-Amz-Content-Sha256");
    canonicalHeaders = canonicalHeaders + ":";
    canonicalHeaders = canonicalHeaders + message:getHeader(msg, string:toLowerCase("X-Amz-Content-Sha256"));
    canonicalHeaders = canonicalHeaders + "\n";
    signedHeader = signedHeader + string:toLowerCase("x-amz-content-sha256");
    signedHeader = signedHeader + ";";

    canonicalHeaders = canonicalHeaders + string:toLowerCase("X-Amz-Date");
    canonicalHeaders = canonicalHeaders + ":";
    canonicalHeaders = canonicalHeaders + (message:getHeader(msg, string:toLowerCase("X-Amz-Date")));
    canonicalHeaders = canonicalHeaders + "\n";
    signedHeader = signedHeader + string:toLowerCase("X-Amz-Date");
    signedHeader = signedHeader;



    canonicalRequest = canonicalRequest + canonicalHeaders;
    canonicalRequest = canonicalRequest + "\n";


    signedHeaders = "";
    signedHeaders = signedHeader;


    canonicalRequest = canonicalRequest + signedHeaders;
    canonicalRequest = canonicalRequest + "\n";



    payloadBuilder = "UNSIGNED-PAYLOAD";

    requestPayload = "";
    requestPayload = payloadBuilder;


    canonicalRequest = canonicalRequest + requestPayload;

    //Start creating the string to sign

    stringToSign = stringToSign + "AWS4-HMAC-SHA256";
    stringToSign = stringToSign + "\n";
    stringToSign = stringToSign + amzDate;
    stringToSign = stringToSign + "\n";

    stringToSign = stringToSign + shortDate;
    stringToSign = stringToSign + "/";
    stringToSign = stringToSign + region;
    stringToSign = stringToSign + "/";
    stringToSign = stringToSign + serviceName;
    stringToSign = stringToSign + "/";
    stringToSign = stringToSign + terminationString;

    stringToSign = stringToSign + "\n";
    stringToSign = stringToSign + string:toLowerCase(util:getHash(canonicalRequest, algorithm));
system:println(stringToSign);
system:println("==============================");
system:println(canonicalRequest);
system:println("==============================");
    signingKey =  util:getHmacFromBase64( terminationString,util:getHmacFromBase64( serviceName,util:getHmacFromBase64( region,util:getHmacFromBase64(shortDate,util:base64encode("AWS4" + secretAccessKey), algorithm), algorithm), algorithm), algorithm);


    authHeader = authHeader + ("AWS4-HMAC-SHA256");
    authHeader = authHeader + (" ");
    authHeader = authHeader + ("Credential");
    authHeader = authHeader + ("=");
    authHeader = authHeader + (accessKeyId);
    authHeader = authHeader + ("/");
    authHeader = authHeader + (shortDate);
    authHeader = authHeader + ("/");
    authHeader = authHeader + (region);
    authHeader = authHeader + ("/");
    authHeader = authHeader + (serviceName);
    authHeader = authHeader + ("/");
    authHeader = authHeader + (terminationString);
    authHeader = authHeader + (",");
    authHeader = authHeader + (" SignedHeaders");
    authHeader = authHeader + ("=");
    authHeader = authHeader + (signedHeaders);
    authHeader = authHeader + (",");
    authHeader = authHeader + (" Signature");
    authHeader = authHeader + ("=");
    authHeader = authHeader + string:toLowerCase(util:getHmacBase16(stringToSign, signingKey, algorithm));

    message:setHeader(msg, "Authorization", authHeader);
system:println(authHeader);
    return msg;

}


function main (string[] args) {

    AmazonS3 s3Connector = create AmazonS3("AKIAIJ2IBQUCKKAL72IA", "AeUD3+Ic9BWH6ZEq+3K7zhxJ/zjzXkuicA883dPd", "us-east-1", "s3", "aws4_request");

    message s3Response;
    int s3Status;
    string s3StringResponse;

    if(args[0]=="getBucketList"){
        s3Response = AmazonS3.getBucketList(s3Connector);
    }else if(args[0]=="getObjectList"){
        s3Response = AmazonS3.getObjectList(s3Connector, "test32512233");
    }else if(args[0]=="createBucket"){
        s3Response = AmazonS3.createBucket(s3Connector, "test32512235");
    }else if(args[0]=="deleteBucket"){
        s3Response = AmazonS3.deleteBucket(s3Connector, "test32512235");
    }else if(args[0]=="getObject"){
        s3Response = AmazonS3.getObject(s3Connector, "test32512233", "test.txt");
    }else if(args[0]=="deleteObject"){
        s3Response = AmazonS3.deleteObject(s3Connector, "test32512233", "test.txt");
    }else if(args[0]=="putObject"){
        s3Response = AmazonS3.putObject(s3Connector, "test32512233", "test.txt", "Sample Content");
    }else{
        system:println("Invalid Action");
    }
    s3Status = http:getStatusCode(s3Response);
    system:println(s3Status);
    s3StringResponse = message:getStringPayload(s3Response);
    system:println(s3StringResponse);
}