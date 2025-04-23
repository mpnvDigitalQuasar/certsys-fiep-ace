package br.org.fiep.esb.cache;

import com.ibm.broker.javacompute.MbJavaComputeNode;
import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;
import com.ibm.broker.plugin.MbGlobalMap;
import com.ibm.broker.plugin.MbMessage;
import com.ibm.broker.plugin.MbMessageAssembly;
import com.ibm.broker.plugin.MbOutputTerminal;
import com.ibm.broker.plugin.MbUserException;
import com.ibm.broker.plugin.MbXMLNSC;

/**
 * 
 *  Classe reponsável por obter o do cache o body de uma determinada árvore lógida de mensagem a partir dos parâmetros de entrada. 
 *  Portanto, se a informação foi encontrada no cache o Body da árvore de mensagem lógica é atualizada, 
 *  caso contrário a árvore de mensagem lógica de saída é igual à de entrada.
 *  
 *  O índice é gerado com o nome do primeiro filho da árvore da mensagem (Primerio filho do Body) contactenado com um indentificador único 
 *  (Environment.Variables.ChaveIndiceParticionado) caso seja fornecido.
 *	
 *  Outra funcionalidade deste componente é guardar o estado se o cache foi atingido no Global Environment para posteriores redirecionamentos em fluxos de mensagens que utilizam este mecanismo de cache:
 *		•	Environment.Variables.CacheAtingido.
 *
 */
public class ObterCacheUtils extends MbJavaComputeNode {

	public void evaluate(MbMessageAssembly inAssembly) throws MbException {
		MbOutputTerminal out = getOutputTerminal("out");
		
		//Propriedades definidas pelo usuario
		String nomeCache = (String) getUserDefinedAttribute("cache");
		
		MbMessage inMessage = inAssembly.getMessage();
		MbMessage outMessage = new MbMessage();
		MbMessageAssembly outAssembly = new MbMessageAssembly(inAssembly,
				outMessage);

		try {
			
			//Obtendo o Cache
			MbGlobalMap cache = MbGlobalMap.getGlobalMap(nomeCache);
			
			//Criando Variavel de controle o Global Environment para verificar se o cache foi atingido
			MbElement variables = outAssembly.getGlobalEnvironment().getRootElement().getFirstElementByPath("Variables");
			MbElement cacheAtingido = null;
			String indiceParticionado = "";
			MbElement chaveIndiceParticionado = null;
			if(variables == null){
				variables = outAssembly.getGlobalEnvironment().getRootElement().createElementAsLastChild(MbXMLNSC.PARSER_NAME);
				variables.setName("Variables");				
			}
			
			cacheAtingido = variables.getFirstElementByPath("CacheAtingido");
			if(cacheAtingido == null){
				cacheAtingido = variables.createElementAsLastChild(MbXMLNSC.PARSER_NAME);
				cacheAtingido.setName("CacheAtingido");
			}
			
			chaveIndiceParticionado = variables.getFirstElementByPath("ChaveIndiceParticionado");
			if(chaveIndiceParticionado != null){
				indiceParticionado = chaveIndiceParticionado.getValueAsString();
				chaveIndiceParticionado.setValue("");
				chaveIndiceParticionado.delete();
			}
			
			String indice = inMessage.getRootElement().getLastChild().getFirstChild().getName();
			indice = indice.substring(0, indice.length() - 6) + indiceParticionado;
			
			//Obtendo o Valor do Cache caso ele exista
			if(cache.containsKey(indice)){
				byte[] valorCache = (byte[]) cache.get(indice);
				copyMessageHeaders(inMessage, outMessage);
				outMessage.getRootElement().createElementAsLastChildFromBitstream(valorCache, MbXMLNSC.PARSER_NAME, "", "", "", 0, 1208, 0);
				cacheAtingido.setValue(true);
			}else{
				outMessage = new MbMessage(inMessage);
				outAssembly = new MbMessageAssembly(inAssembly, outMessage);
				cacheAtingido.setValue(false);
			}
			
		} catch (MbException e) {
			throw e;
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new MbUserException(this, "evaluate()", "", "", e.toString(),
					null);
		}
	
		
		out.propagate(outAssembly);
	}
	
	/**
	 * Copiar o Cabecalho da arvore logica de mensagem.
	 * @param inMessage - arvore de mensagem logica de entrada
	 * @param outMessage - arvore de mensagem logica de saida
	 * @throws MbException - Excecao durante a copia do cabecalho
	 */
	public void copyMessageHeaders(MbMessage inMessage, MbMessage outMessage)
			throws MbException {
		MbElement outRoot = outMessage.getRootElement();

		// Iterar sobre o cabecalho
		MbElement header = inMessage.getRootElement().getFirstChild();
		while (header != null && header.getNextSibling() != null) // Para antes do Body
		{
			outRoot.addAsLastChild(header.copy());
			header = header.getNextSibling();
		}
	}

}
