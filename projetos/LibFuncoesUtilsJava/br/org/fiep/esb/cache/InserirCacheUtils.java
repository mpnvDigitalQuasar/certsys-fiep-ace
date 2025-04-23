package br.org.fiep.esb.cache;

import com.ibm.broker.javacompute.MbJavaComputeNode;
import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;
import com.ibm.broker.plugin.MbGlobalMap;
import com.ibm.broker.plugin.MbGlobalMapSessionPolicy;
import com.ibm.broker.plugin.MbMessage;
import com.ibm.broker.plugin.MbMessageAssembly;
import com.ibm.broker.plugin.MbOutputTerminal;
import com.ibm.broker.plugin.MbUserException;

/**
 * Este Classe Java tem com objetivo inserir o Body da árvore de mensagem lógica no cache, 
 * para isso faz utilização dos parâmetros de entrada do sub fluxo para identificar qual o cache e qual índice de inserção, sendo eles:
 *	•	cache: nome do cache para inserir o Body da árvore de mensagem lógica do Broker;
 *	•	tempoVida: indica em minutos o tempo em que os dados irão expirar no cache.
 *
 * O índice é gerado com o nome do primeiro filho da árvore da mensagem (Primerio filho do Body) contactenado com um indentificador único 
 * (Environment.Variables.ChaveIndiceParticionado) caso seja fornecido.
 *
 * Portanto, a partir desses parâmetros de entrada é realizada a inserção ou atualização (caso o índice já exista no cache) do Body da árvore de mensagem lógica corrente. 
 * Neste fluxo a árvore de mensagem lógica não á alterar e sim somente guardada no cache.
 *
 */
public class InserirCacheUtils extends MbJavaComputeNode {

	public void evaluate(MbMessageAssembly inAssembly) throws MbException {
		MbOutputTerminal out = getOutputTerminal("out");
		
		//Propriedades definidas pelo usuario
		String nomeCache = (String) getUserDefinedAttribute("cache");
		Integer tempoVida = Integer.parseInt((String) getUserDefinedAttribute("tempoVida"))*3600;
		
		MbMessage inMessage = inAssembly.getMessage();
		MbMessageAssembly outAssembly = null;
		try {
			
			MbMessage outMessage = new MbMessage(inMessage);
			outAssembly = new MbMessageAssembly(inAssembly, outMessage);
			
			// Verificando a possibilidade de utilizacao de um indice particionado
			MbElement variables = outAssembly.getGlobalEnvironment().getRootElement().getFirstElementByPath("Variables");
			String indiceParticionado = "";
			MbElement chaveIndiceParticionado = null;
			
			if(variables != null){
				chaveIndiceParticionado = variables.getFirstElementByPath("ChaveIndiceParticionado");
				if(chaveIndiceParticionado != null){
					indiceParticionado = chaveIndiceParticionado.getValueAsString();
					chaveIndiceParticionado.setValue("");
					chaveIndiceParticionado.delete();
				}
			}
			
			//Obtendo o cache com TTL
			MbGlobalMap cache = MbGlobalMap.getGlobalMap(nomeCache, new MbGlobalMapSessionPolicy(tempoVida));
			
			//Atualizando o cache - o objeto a ser inserido ou atualizado no cache deve ser byte[], pois este objeto pode ser serializado
			String indice = inMessage.getRootElement().getLastChild().getFirstChild().getName();
			indice = indice.substring(0, indice.length() - 6) + indiceParticionado;
			
			if(cache.containsKey(indice)){
				cache.update(indice, outMessage.getRootElement().getLastChild().toBitstream("", "", "", 0, 1208, 0));
			}else{
				cache.put(indice, outMessage.getRootElement().getLastChild().toBitstream("", "", "", 0, 1208, 0));
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

}
