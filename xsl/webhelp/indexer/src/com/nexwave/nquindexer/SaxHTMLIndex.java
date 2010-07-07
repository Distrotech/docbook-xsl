package com.nexwave.nquindexer;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;


// specific dita ot
import com.nexwave.nsidita.DocFileInfo;
/**
 * Parser for the html files generated by DITA-OT.
 * Extracts the title, the shortdesc and all the text within tags
 * 
 * @version 1.0 2008-0226
 * 
 * @author N. Quaine
 */
public class SaxHTMLIndex extends SaxDocFileParser{
	
	//members
	private Map tempDico;
	private int i = 0;
	private ArrayList <String> cleanUpList = null;
	private ArrayList <String> cleanUpPunctuation = null;

	//methods
	/**
	 * Constructor
	 */
	public SaxHTMLIndex () {
		super();
	}
	/**
	 * Constructor
	 */
	public SaxHTMLIndex (ArrayList <String> cleanUpStrings) {
		super();
		cleanUpList = cleanUpStrings;
	}
	/**
	 * Constructor
	 */
	public SaxHTMLIndex (ArrayList <String> cleanUpStrings, ArrayList <String> cleanUpChars) {
		super();
		cleanUpList = cleanUpStrings;
		cleanUpPunctuation = cleanUpChars;
	}
	
	/**
	 * Initializer
	 */
	public int init(Map tempMap){
		tempDico = tempMap;
		return 0;	
	}

	/**
	 * Parses the file to extract all the words for indexing and 
	 * some data characterizing the file. 
	 * @param file contains the fullpath of the document to parse  
	 * @return a DitaFileInfo object filled with data describing the file
	 */
	public DocFileInfo runExtractData(File file) {
		//initialization
		fileDesc = new DocFileInfo(file);
		strbf = new StringBuffer("");
		
		// Fill strbf by parsing the file
		parseDocument(file);
		
		String str = cleanBuffer(strbf);

		//System.out.println(file.toString()+" "+ str +"\n");
		String[] items = str.split("\\s");
		//items: remove the duplicated strings first
		HashSet <String> tempSet = new HashSet<String>();
		for (String s : items) {
			tempSet.add(s);
		}
		Iterator it = tempSet.iterator();
		String s;
        while (it.hasNext()) {
            //System.out.println(s);
        	s = (String)it.next();
        	if (tempDico.containsKey(s)) {
        		String temp = (String) tempDico.get(s);
        		temp = temp.concat(",").concat(new Integer(i).toString());
        		//System.out.println("temp="+s+"="+temp);
        		tempDico.put(s, temp);
        	}else {
        		tempDico.put(s, new Integer(i).toString());
        	}
        }
        
        i++;
		return fileDesc;
	}

	/**
	 * Cleans the string buffer containing all the text retrieved from 
	 * the html file:  remove punctuation, clean white spaces, remove the words 
	 * which you do not want to index.
	 * NOTE: You may customize this function:
	 * This version takes into account english and japanese. Depending on your 
	 * needs, 
	 * you may have to add/remove some characters/words through props files 
	 *    or by modifying tte default code,
	 * you may want to separate the language processing (doc only in japanese, 
	 * doc only in english, check the language metadata ...). 
	 */
	private String cleanBuffer (StringBuffer strbf) {
		String str = strbf.toString().toLowerCase();
		StringBuffer tempStrBuf = new StringBuffer("");
		StringBuffer tempCharBuf = new StringBuffer("");
		if ((cleanUpList == null) || (cleanUpList.isEmpty())){
			// Default clean-up
			
			// Il faut peut-etre eliminer les mots a la fin du tableau?
			tempStrBuf.append("\\bthe\\b|\\ba\\b|\\ban\\b|\\bto\\b|\\band\\b|\\bor\\b");
			tempStrBuf.append("|\\bis\\b|\\bare\\b|\\bin\\b|\\bwith\\b|\\bbe\\b|\\bcan\\b");
			tempStrBuf.append("|\\beach\\b|\\bhas\\b|\\bhave\\b|\\bof\\b|\\b\\xA9\\b|\\bnot\\b");
			tempStrBuf.append("|\\bfor\\b|\\bthis\\b|\\bas\\b|\\bit\\b|\\bhe\\b|\\bshe\\b");
			tempStrBuf.append("|\\byou\\b|\\bby\\b|\\bso\\b|\\bon\\b|\\byour\\b|\\bat\\b");
			tempStrBuf.append("|\\b-or-\\b|\\bso\\b|\\bon\\b|\\byour\\b|\\bat\\b");

			str = str.replaceFirst("Copyright � 1998-2007 NexWave Solutions.", " ");
			

			//nqu 25.01.2008 str = str.replaceAll("\\b.\\b|\\\\", " ");
			// remove contiguous white charaters
			//nqu 25.01.2008 str = str.replaceAll("\\s+", " ");			
		}else {
			// Clean-up using the props files
			tempStrBuf.append("\\ba\\b");
			Iterator it = cleanUpList.iterator();
			while (it.hasNext()){
				tempStrBuf.append("|\\b"+it.next()+"\\b");
			}
		}
		if ((cleanUpPunctuation != null) && (!cleanUpPunctuation.isEmpty())){
			tempCharBuf.append("\\u3002");
			Iterator it = cleanUpPunctuation.iterator();
			while (it.hasNext()){
				tempCharBuf.append("|"+it.next());
			}
		}

		str = minimalClean(str, tempStrBuf, tempCharBuf);
		return str;
	}
	
	private String minimalClean(String str, StringBuffer tempStrBuf, StringBuffer tempCharBuf) {
		String tempPunctuation = new String(tempCharBuf);
		
		str = str.replaceAll("\\s+", " ");
		str = str.replaceAll("->", " ");
		str = str.replaceAll(IndexerConstants.EUPUNCTUATION1, " ");
		str = str.replaceAll(IndexerConstants.EUPUNCTUATION2, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION1, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION2, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION3, " ");
		if (tempPunctuation.length() > 0)
		{
			str = str.replaceAll(tempPunctuation, " ");
		}

		//remove useless words
		str = str.replaceAll(tempStrBuf.toString(), " ");
		
		// Redo punctuation after removing some words: (TODO: useful?)
		str = str.replaceAll(IndexerConstants.EUPUNCTUATION1, " ");
		str = str.replaceAll(IndexerConstants.EUPUNCTUATION2, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION1, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION2, " ");
		str = str.replaceAll(IndexerConstants.JPPUNCTUATION3, " ");		
		if (tempPunctuation.length() > 0)
		{
			str = str.replaceAll(tempPunctuation, " ");
		}		return str;
	}

}