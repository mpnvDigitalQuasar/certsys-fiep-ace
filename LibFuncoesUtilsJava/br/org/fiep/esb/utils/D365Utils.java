package br.org.fiep.esb.utils;

import javax.naming.ServiceUnavailableException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import org.json.JSONObject;

import com.ibm.broker.plugin.MbElement;

public class D365Utils {

	public static void main(String[] args) {

		String resource = "https://fiep-devsb-v072023a57a3be481a63c0caos.cloudax.dynamics.com";
		String clientId = "61124478-93da-4972-bb49-a24118166133";
		String secret = "3Oo8Q~6Xe7islAnfUJIG_HKLjcZv4jrmJqcUzavh";
		String urlLogin = "https://login.windows.net/sistemafiep.onmicrosoft.com/oauth2/token";

		// String authority =
		// "https://login.windows.net/fiepr.org.br/0b24ceb0-90d8-4fe0-92ae-05a9c18acd11";
		// String resource =
		// "https://fiep-devsb-v072023a57a3be481a63c0caos.cloudax.dynamics.com";
		// String clientId = "0b24ceb0-90d8-4fe0-92ae-05a9c18acd11";
		// String username = "service_axbpm@fiepr.org.br";
		// String password = "$ErVicE*@CC0unTaXBpM";

		gerarToken(resource, clientId, secret, urlLogin, null);

	}

	public static void gerarToken(String resource, String clientId,
			String clientSecret, String urlLogin, MbElement[] env) {
		try {
			
			
			Response result = getAccessTokenFromUserCredentials(resource,
					clientId, clientSecret, urlLogin);

			JSONObject json = new JSONObject(result.body().string());
			
			if (env != null){
				MbElement environment = env[0];
				MbElement variables = environment.getFirstElementByPath("Variables");
				variables.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "Authorization", "Bearer "+json.getString("access_token"));
			} else {
				System.out.println(json.getString("access_token"));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
	}

	private static Response getAccessTokenFromUserCredentials(String resource,
			String clientId, String clientSecret, String urlLogin) throws Exception {

		OkHttpClient client = new OkHttpClient().newBuilder()

		.build();

		MediaType mediaType = MediaType
				.parse("application/x-www-form-urlencoded");

		String url = "resource=".concat(resource).concat("&client_id=")
				.concat(clientId).concat("&client_secret=")
				.concat(clientSecret).concat("&client_info=").concat("1")
				.concat("&grant_type=").concat("client_credentials");

		RequestBody body = RequestBody.create(mediaType, url);

		// "resource=&client_id=&client_secret=&client_info=1&grant_type=client_credentials");

		Request request = new Request.Builder()
				.url(urlLogin)
				.method("POST", body)
				.addHeader("Content-Type", "application/x-www-form-urlencoded")
				.build();

		Response response = client.newCall(request).execute();

		if (response == null) {
			throw new ServiceUnavailableException(
					"authentication result was null");
		}
		return response;
	}
}
