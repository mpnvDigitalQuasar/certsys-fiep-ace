package br.org.fiep.esb.utils;


import java.util.List;

import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;
import com.ibm.broker.plugin.MbJSON;
import com.ibm.integration.admin.model.*;
import com.ibm.integration.admin.proxy.*;
							  

/*
 * IIB 10
 * Deprecated com.ibm.broker.config.proxy
 * This is the reference documentation for the IBM Integration API:
 * 		https://www.ibm.com/docs/en/integration-bus/10.0?topic=SSMKHH_10.0.0/com.ibm.etools.mft.cmp.doc/com/ibm/broker/config/proxy/package-summary.html
 * Exemples:
 * 		https://www.ibm.com/docs/en/integration-bus/10.0?topic=api-navigating-integration-nodes-integration-node-resources
 * 
 * ACE 12
 * New com.ibm.integration.admin.proxy
 * This is the reference documentation for the IBM Integration API:
 * 		https://www.ibm.com/docs/en/app-connect/12.0?topic=SSTTDS_12.0/com.ibm.etools.mft.cmp.doc/com/ibm/broker/config/proxy/package-summary.html
 * 		https://www.ibm.com/docs/en/app-connect/12.0?topic=SSTTDS_12.0/com.ibm.etools.mft.cmp.doc/com/ibm/integration/admin/proxy/package-summary.html
 * Exemples:
 * 		https://www.ibm.com/docs/en/app-connect/12.0?topic=api-navigating-integration-nodes-integration-node-resources
 */

public class BrokerUtils {    

	public static void main(String[] args) {          	    	
		// The IP address of where the integration node is running
		// and the web administration port number of the integration node.
		displayBrokerRunState("localhost", 4414);
		
	}     

	public static void displayBrokerRunState(String hostname, int port) {        

		IntegrationNodeProxy node = null;
		
		try {    
			//Conexão com o IIB
			node = new IntegrationNodeProxy(hostname, port, "swaggerui", "swPassw0rd", false);
			
			String brokerName = node.getName(); 
			//Imprimindo o Integration Node 
			System.out.println("Integration node '"+brokerName+"' está disponível!");  
			
					
			//Pegando a lista de Integrations Servers
			List<IntegrationServerProxy> listIntServers = node.getAllIntegrationServers();
					
			//Incremento para pegar os recursos dos Integrations Servers
			for(IntegrationServerProxy currentServer: listIntServers){ 
			 
				//Imprimindo o Integration Server
				 System.out.println("Found : "+currentServer.getName());
				 								 
				 //Pegando a lista de Application, RestApi, SharedLibrary e ServiceProxy
				 List<RestApiProxy> listRestApi = currentServer.getAllRestApis(true);
				 List<SharedLibraryProxy> listSharedLibrary = currentServer.getAllSharedLibraries(true);
				 List<ApplicationProxy> listApplications = currentServer.getAllApplications(true);
				 //List<ServiceProxy> listServiceProxy = currentServer.getAllServices(true);
				 				 
				 //Inicio imprimindo a RestApi
				 for(RestApiProxy currentRest: listRestApi) { 
					RestApiModel restModel = currentRest.getRestApiModel(true);
					 
					System.out.println("apiName " + currentRest.getName());											
					System.out.println("type " + restModel.getType());
					System.out.println("barFileName " + restModel.getDescriptiveProperties().getDeployBarfile());
					System.out.println("definitionsURL  " + restModel.getActive().getDefinitionsURL());
					System.out.println("baseURL  " + restModel.getActive().getBaseURL());
					System.out.println("localDefinitionsURL  " + restModel.getActive().getDefinitionsURL());
					System.out.println("localBaseURL  " + restModel.getActive().getBaseURL());
					System.out.println("monitoring  " + restModel.getActive().getMonitoring());
					System.out.println("javaIsolation  " + restModel.getProperties().isJavaIsolation());
					System.out.println("label " + restModel.getName());
					System.out.println("uuid " + "");
					System.out.println("version " + "");
					System.out.println("runMode " +restModel.getProperties().getStartMode());
					System.out.println("isRunning " + restModel.getActive().isRunning());
					System.out.println("startMode " + restModel.getProperties().getStartMode());
					System.out.println("deployTime " + restModel.getDescriptiveProperties().getDeployTimestamp());
					System.out.println("modifyTime " + restModel.getDescriptiveProperties().getLastModified());									
					System.out.println("shortDesc " + restModel.getDescriptiveProperties().getShortDesc());
					System.out.println("longDesc " + restModel.getDescriptiveProperties().getLongDesc());
					System.out.println("mainFlow " + restModel.getChildren().getMessageFlows().getName());
					System.out.println("dataCaputreSource " + "--");
					System.out.println("dataCaputreStore " + "--");
					System.out.println("topic " + "--");
					
				 }
				 //Fim imprimindo a RestApi
				
				 //Inicio imprimindo a SharedLibrary
				 for(SharedLibraryProxy currentLib: listSharedLibrary) {
					SharedLibraryModel libModel = currentLib.getSharedLibraryModel(true);
					 
					System.out.println("librayName " + currentLib.getName());
					System.out.println("librayName " + libModel.getName());
					System.out.println("type " + libModel.getType());
					System.out.println("definitionsURL " + libModel.getUri());
					System.out.println("barFileName " + libModel.getDescriptiveProperties().getDeployBarfile());
					System.out.println("label " + libModel.getName());
					System.out.println("uuid " + "--");
					System.out.println("version " + "--");
					System.out.println("deployTime " + libModel.getDescriptiveProperties().getDeployTimestamp());
					System.out.println("modifyTime " + libModel.getDescriptiveProperties().getLastModified());
					System.out.println("shortDesc " + "");
					System.out.println("longDesc " + "");
					System.out.println("dataCaputreSource " + "--");
					System.out.println("dataCaputreStore " + "--");
					System.out.println("topic " + "--");

				 }
				 //Fim imprimindo a SharedLibrary
				 
				 //Inicio imprimindo a Application
				 for(ApplicationProxy currentApp: listApplications) {
					 ApplicationModel appModel = currentApp.getApplicationModel(true);
					 
					 System.out.println("appName " + appModel.getName());
					 System.out.println("type " + appModel.getType());
					 System.out.println("barFileName " + appModel.getDescriptiveProperties().getDeployBarfile());
					 System.out.println("definitionsURL " + appModel.getUri());						
					 System.out.println("monitoring " + appModel.getActive().getMonitoring());
					 System.out.println("javaIsolation " + appModel.getProperties().isJavaIsolation());
					 System.out.println("label " + appModel.getName());
					 System.out.println("uuid " + "--");
					 System.out.println("version " + "--");
					 System.out.println("runMode " +appModel.getProperties().getStartMode());
					 System.out.println("isRunning " + appModel.getActive().isRunning());
					 System.out.println("startMode " + appModel.getProperties().getStartMode());
					 System.out.println("deployTime " + appModel.getDescriptiveProperties().getDeployTimestamp());
					 System.out.println("modifyTime " + appModel.getDescriptiveProperties().getLastModified());									
					 System.out.println("shortDesc " + appModel.getDescriptiveProperties().getShortDesc());
					 System.out.println("longDesc " + appModel.getDescriptiveProperties().getLongDesc());
					 System.out.println("mainFlow " + appModel.getChildren().getMessageFlows().getName());
					 System.out.println("dataCaputreSource " + "--");
					 System.out.println("dataCaputreStore " + "--");
					 System.out.println("topic " + "--");
					 
				 }
				 //Fim imprimindo a Application
				 
	         }  
			
		}catch (IntegrationAdminException ex) {           
			System.out.println("Integration node is NOT available"+" because "+ex);    
		}catch (NumberFormatException ex){
			ex.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
		
		
	public static void obterIIBInfo(String servidor, String porta, MbElement[] outputRoot) {        

			if (servidor == null) servidor = "localhost";
			if (porta == null) porta = "4414";

			IntegrationNodeProxy node = null;
			
			try {    
				int portaInt = Integer.parseInt(porta);
				//Conexão com o IIB
				node = new IntegrationNodeProxy(servidor, portaInt, "swaggerui", "swPassw0rd", false);
								
				String brokerName = node.getName(); 
				//Imprimindo o Integration Node 
				System.out.println("Integration node '"+brokerName+"' está disponível!");  
	            
				//Inicio criação do OutputRoot
				MbElement root = outputRoot[0];
				MbElement json = root.createElementAsLastChild(MbJSON.PARSER_NAME);	
				MbElement data = json.createElementAsLastChild(MbElement.TYPE_NAME, MbJSON.DATA_ELEMENT_NAME, null);
		
				@SuppressWarnings("unused")
				MbElement brokerInfo = data.createElementAsLastChild(MbElement.TYPE_NAME, "integrationNode", brokerName);	
				brokerInfo = data.createElementAsLastChild(MbElement.TYPE_NAME, "integrationServer", "ApiServices");
				MbElement itens = data.createElementAsLastChild(MbJSON.ARRAY, "deployedBars", null);
				//Fim criação do OutputRoot
				
				//Pegando a lista de Integrations Servers
				List<IntegrationServerProxy> listIntServers = node.getAllIntegrationServers();
						
				//Incremento para pegar os recursos dos Integrations Servers
				for(IntegrationServerProxy currentServer: listIntServers){ 
				 
					//Imprimindo o Integration Server
					 System.out.println("Found : "+currentServer.getName());
					 								 
					 //Pegando a lista de Application, RestApi, SharedLibrary e ServiceProxy
					 List<RestApiProxy> listRestApi = currentServer.getAllRestApis(true);
					 List<SharedLibraryProxy> listSharedLibrary = currentServer.getAllSharedLibraries(true);
					 List<ApplicationProxy> listApplications = currentServer.getAllApplications(true);
					 //List<ServiceProxy> listServiceProxy = currentServer.getAllServices(true);
					 				 
					 //Inicio imprimindo a RestApi
					 for(RestApiProxy currentRest: listRestApi) { 
						RestApiModel restModel = currentRest.getRestApiModel(true);
						 
						System.out.println("apiName " + currentRest.getName());	
						
						MbElement item = itens.createElementAsLastChild(MbElement.TYPE_NAME, MbJSON.ARRAY_ITEM_NAME, null);					
						item.createElementAsLastChild(MbElement.TYPE_NAME, "apiName", currentRest.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "type", restModel.getType());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "barFileName", restModel.getDescriptiveProperties().getDeployBarfile());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "definitionsURL", restModel.getActive().getDefinitionsURL());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "baseURL", restModel.getActive().getBaseURL());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "localDefinitionsURL", restModel.getActive().getDefinitionsURL());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "localBaseURL", restModel.getActive().getBaseURL());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "monitoring", restModel.getActive().getMonitoring());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "javaIsolation", restModel.getProperties().isJavaIsolation());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "label", restModel.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "uuid", "");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "version", "");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "runMode",restModel.getProperties().getStartMode());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "isRunning", restModel.getActive().isRunning());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "startMode", restModel.getProperties().getStartMode());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "deployTime", restModel.getDescriptiveProperties().getDeployTimestamp());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "modifyTime", restModel.getDescriptiveProperties().getLastModified());									
						item.createElementAsLastChild(MbElement.TYPE_NAME, "shortDesc", restModel.getDescriptiveProperties().getShortDesc());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "longDesc", restModel.getDescriptiveProperties().getLongDesc());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "mainFlow", restModel.getChildren().getMessageFlows().getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreSource", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreStore", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "topic", "--");
					 }
					 //Fim imprimindo a RestApi
					
					 //Inicio imprimindo a SharedLibrary
					 for(SharedLibraryProxy currentLib: listSharedLibrary) {
						SharedLibraryModel libModel = currentLib.getSharedLibraryModel(true);
						 
						System.out.println("librayName " + currentLib.getName());
				
						MbElement item = itens.createElementAsLastChild(MbElement.TYPE_NAME, MbJSON.ARRAY_ITEM_NAME, null);					
						item.createElementAsLastChild(MbElement.TYPE_NAME, "librayName", libModel.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "type", libModel.getType());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "definitionsURL", libModel.getUri());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "barFileName", libModel.getDescriptiveProperties().getDeployBarfile());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "label", libModel.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "uuid", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "version", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "deployTime", libModel.getDescriptiveProperties().getDeployTimestamp());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "modifyTime", libModel.getDescriptiveProperties().getLastModified());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "shortDesc", "");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "longDesc", "");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreSource", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreStore", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "topic", "--");
					 }
					 //Fim imprimindo a SharedLibrary
					 
					 //Inicio imprimindo a Application
					 for(ApplicationProxy currentApp: listApplications) {
						 ApplicationModel appModel = currentApp.getApplicationModel(true);
						 System.out.println("appName " + currentApp.getName());

						MbElement item = itens.createElementAsLastChild(MbElement.TYPE_NAME, MbJSON.ARRAY_ITEM_NAME, null);					
						item.createElementAsLastChild(MbElement.TYPE_NAME, "appName", appModel.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "type", appModel.getType());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "barFileName", appModel.getDescriptiveProperties().getDeployBarfile());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "definitionsURL", appModel.getUri());						
						item.createElementAsLastChild(MbElement.TYPE_NAME, "monitoring", appModel.getActive().getMonitoring());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "javaIsolation", appModel.getProperties().isJavaIsolation());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "label", appModel.getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "uuid", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "version", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "runMode",appModel.getProperties().getStartMode());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "isRunning", appModel.getActive().isRunning());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "startMode", appModel.getProperties().getStartMode());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "deployTime", appModel.getDescriptiveProperties().getDeployTimestamp());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "modifyTime", appModel.getDescriptiveProperties().getLastModified());									
						item.createElementAsLastChild(MbElement.TYPE_NAME, "shortDesc", appModel.getDescriptiveProperties().getShortDesc());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "longDesc", appModel.getDescriptiveProperties().getLongDesc());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "mainFlow", appModel.getChildren().getMessageFlows().getName());
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreSource", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "dataCaputreStore", "--");
						item.createElementAsLastChild(MbElement.TYPE_NAME, "topic", "--");
						 
					 }
					 //Fim imprimindo a Application
					 
		         }  
				
			}catch (IntegrationAdminException ex) {           
				System.out.println("Integration node is NOT available"+" because "+ex);    
			}catch (NumberFormatException ex){
				ex.printStackTrace();
			} catch (MbException e) {			
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
}