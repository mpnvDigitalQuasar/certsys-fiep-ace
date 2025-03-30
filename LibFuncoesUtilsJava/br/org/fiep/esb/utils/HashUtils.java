package br.org.fiep.esb.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.UUID;
import java.math.*;

import com.ibm.broker.plugin.MbElement;
import com.ibm.broker.plugin.MbException;



public class HashUtils {

	public static void obterMD5(String base64, MbElement[] env) {

		//Use MD5 algorithm
		MessageDigest md5Digest;
		try {
			md5Digest = MessageDigest.getInstance("MD5");
			byte[] bytes = Base64.getDecoder().decode(base64);

			String tempFolder = System.getProperty("java.io.tmpdir");

			File file = new File(tempFolder+UUID.nameUUIDFromBytes(bytes));

			try {
				OutputStream os = new FileOutputStream(file);
				os.write(bytes);
				System.out.println("Write bytes to file.");
				os.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

			String md5 = getFileChecksum(md5Digest, file);

			MbElement variables = env[0].getFirstElementByPath("Variables");
			variables.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "md5", md5);

			file.delete();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MbException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

	public static void obterMD5Txt(String txt, MbElement[] env) {

		//Use MD5 algorithm
		MessageDigest md5Digest;
		try {
			md5Digest = MessageDigest.getInstance("MD5");
			
			md5Digest.update(txt.getBytes(),0,txt.length());
			
		   String md5 = new BigInteger(1,md5Digest.digest()).toString(16);

			MbElement variables = env[0].getFirstElementByPath("Variables");
			variables.createElementAsLastChild(MbElement.TYPE_NAME_VALUE, "md5", md5);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

		
	
	
	private static String getFileChecksum(MessageDigest digest, File file) throws IOException
	{
		//Get file input stream for reading the file content
		FileInputStream  fis = new FileInputStream(file);

		//Create byte array to read data in chunks
		byte[] byteArray = new byte[1024];
		int bytesCount = 0;

		//Read file data and update in message digest
		while ((bytesCount = fis.read(byteArray)) != -1) {
			digest.update(byteArray, 0, bytesCount);
		};

		//close the stream; We don't need it now.
		fis.close();

		//Get the hash's bytes
		byte[] bytes = digest.digest();

		//This bytes[] has bytes in decimal format;
		//Convert it to hexadecimal format
		StringBuilder sb = new StringBuilder();
		for(int i=0; i< bytes.length ;i++)
		{
			sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
		}

		//return complete hash
		return sb.toString();
	}
}
