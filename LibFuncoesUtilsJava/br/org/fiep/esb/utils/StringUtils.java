package br.org.fiep.esb.utils;

import java.text.Normalizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.sql.Timestamp;
import java.util.Date;
import java.util.concurrent.TimeUnit;



import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;

public class StringUtils {

	public static String geraData(String dataRecebida) {
        long inputLong = Long.parseLong( dataRecebida );  
        long input = ( inputLong * 1000L ); 

       Timestamp outputTimestamp = new Timestamp(input);
       
       String str=outputTimestamp.toString();  
       System.out.println( "Tempo em string: " +str);  
       
		return str;
    }
	public static String removerAcento(String x) {
		if (x != null) {
			return Normalizer.normalize(x, Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");
		} else {
			return null;
		}
	}

	public static String removeInvalidXMLCharacters(String in) {
		StringBuffer out = new StringBuffer(); // Used to hold the output.
		char current; // Used to reference the current character.

		if (in == null || ("".equals(in)))
			return ""; // vacancy test.
		for (int i = 0; i < in.length(); i++) {
			current = in.charAt(i); // NOTE: No IndexOutOfBoundsException caught here; it should not happen.
			if ((current == 0x9) || (current == 0xA) || (current == 0xD) || ((current >= 0x20) && (current <= 0xD7FF))
					|| ((current >= 0xE000) && (current <= 0xFFFD)) || ((current >= 0x10000) && (current <= 0x10FFFF)))
				out.append(current);
		}
		return out.toString();
	}

	public static String primeiraLetraMaiusucla(String nomeCompleto) {
		String nomeModificado = "";
		if (nomeCompleto != null) {
			int posicao = 1; // Foi atribuído um valor 1 p/ poder entrar no laço.
			while (posicao > 0) {
				nomeCompleto = nomeCompleto.replace("  ", " ");
				posicao = nomeCompleto.indexOf("  ");
			}
			nomeCompleto = nomeCompleto.trim(); // remove espaços à esquerda e direita, se houver.

			String nomes[] = nomeCompleto.split(" ");
			for (int i = 0; i < nomes.length; i++) {
				nomes[i] = nomes[i].substring(0, 1).toUpperCase()
						+ nomes[i].substring(1, nomes[i].length()).toLowerCase();

				/*
				 * Os nomes foram separados, correto? Portanto temos que juntá-los novamente.
				 * Para isso fiz um 'JOIN', aproveitando o próprio laço
				 */

				nomeModificado = nomeModificado + " " + nomes[i];

				/*
				 * nomeModificado = nomeModificado.replace(" De ", " de "); nomeModificado =
				 * nomeModificado.replace(" Do ", " do "); nomeModificado =
				 * nomeModificado.replace(" Dos ", " dos "); nomeModificado =
				 * nomeModificado.replace(" Da ", " da "); nomeModificado =
				 * nomeModificado.replace(" Das ", " das ");
				 */
			}
			return nomeModificado.trim();
		} else {
			return null;
		}
	}

	public static String primeiroNome(String nomeCompleto) {

		if (nomeCompleto != null) {
			nomeCompleto = nomeCompleto.replace("  ", " ");
			return nomeCompleto.split(" ")[0];
		} else {
			return null;
		}

	}

	public static String ultimoNome(String nomeCompleto) {

		if (nomeCompleto != null) {
			nomeCompleto = nomeCompleto.replace("  ", " ");
			String split[] = nomeCompleto.split(" ");
			return split[split.length - 1];
		} else {
			return null;
		}

	}

	public static String retiraPrimeiroNome(String nomeCompleto) {

		if (nomeCompleto != null) {
			nomeCompleto = nomeCompleto.replace("  ", " ");
			String split[] = nomeCompleto.split(" ");
			String semPrimeiroNome = "";

			for (int i = 1; i < split.length; i++) {
				semPrimeiroNome += split[i] + " ";
			}
			return semPrimeiroNome.trim();
		} else {
			return null;
		}

	}

	public static Boolean duasCasasDecimais(String valor) {

		Pattern p = Pattern.compile("\\d+\\.\\d{2}");
		Matcher m = p.matcher(valor);
		boolean b = m.matches();

		return b;
	}

	public static String listToString(MbElement lista) {

		String listaConcatenada = "";

		try {
			do {

				listaConcatenada += lista.getValueAsString();

				lista = lista.getNextSibling();

				if (lista != null)
					listaConcatenada += ",";
			} while (lista != null);

		} catch (MbException e) {

			e.printStackTrace();
		}

		return listaConcatenada;
	}
}
