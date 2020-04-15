package UserUserRecommendation;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeMap;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
class Prediction{
	public TreeMap<Double, Integer> PredictScore(double[][] a, double[][] b, double mean, TreeMap<Double, Integer> neighbour, int row, int col)
	{
		TreeMap<Double, Integer> predict = new TreeMap<Double, Integer>(Collections.reverseOrder());
		for (int j=0; j< row; j++){
			double score=0.0,counter=0.0;
			Set set = neighbour.entrySet();
	        Iterator it = set.iterator();
			for(int i=0;i<10;i++)
			{
	        	Map.Entry me = (Map.Entry)it.next();
				double weight=(double) me.getKey();
				int user = (int) me.getValue();
				if(b[j][user]!=0.0)
				{
					score=score+(weight*a[j][user]);
					counter=counter+weight;
				}
			}
			score=score/counter;
			score=score+mean;
			predict.put(score, j);
		}
			
		return predict;
		
	}
	
}
class correlation{
	public TreeMap<Double, Integer> Neighbours(double[][] a, double[][] b, int row, int col)
	{
		TreeMap<Double, Integer> neighbourhood=new TreeMap<Double, Integer>(Collections.reverseOrder());
		double[] corr=CorrCalc(a,b,row,col);
		for(int i=0; i<col-1; i++)
		{
			neighbourhood.put(corr[i], i);
		}
		return neighbourhood;
	}
	public double[]CorrCalc (double[][] a, double[][] b, int row, int col)
	{
		double[] corr = new double[col];
		double numerator=0.0;
		double denominator=0.0;

		
			for (int j=0; j< col; j++)
			{
				numerator=numeratorCalc(25,j,a,b);
				denominator=denominatorCalc(25,j,a,b);
				corr[j]=numerator/denominator;
				numerator=0.0;
				denominator=0.0;
			}
		
		return corr;
	}
	public double numeratorCalc(int user1, int user2, double[][] a, double[][] b)
	{
		double numerator=0.0;
		int length=a.length;
		for(int i= 0; i<length;i++ )
		{
			if (b[i][user1]!=0.0 && b[i][user2]!=0.0)
			{
				numerator=numerator+(a[i][user1]*a[i][user2]);
			}
					
		}
		return numerator;
	}
	public double denominatorCalc(int user1, int user2, double[][] a, double[][] b)
	{
		double denominator=0.0;
		double part1=0.0;
		double part2=0.0;
		for (int i=0; i<a.length;i++)
		{
			if (b[i][user1]!=0.0 && b[i][user2]!=0.0)
			{
				part1=part1+Math.pow(a[i][user1],2);
				part2=part2+Math.pow(a[i][user2],2);
			}
		}
		denominator=Math.sqrt(part1)*Math.sqrt(part2);
		return denominator;
	}
}
class Normalization{
	public double[] MeanCalc(double[][] a, double[][] b, int row, int col){
		double[] meanRating=new double[col];
		int counter=0;
		double sum=0.0;
		for (int i=0; i<col; i++)
		{
			for (int j=0; j<row; j++)
			{
				if (b[j][i]==1.0){
					counter=counter+1;
					sum=sum+a[j][i];
				}
									
			}
			meanRating[i]=sum/counter;
			sum=0.0;
			counter=0;
			
		}
		
		return meanRating;
	}
	public double[][] RatingNormalize(double[][] a, double[][] b, int row, int col, double[] mean){
		double[][] result= new double[row][col];
		for (int j=0; j<col; j++){
		for (int i=0; i<row; i++){
			
				if (b[i][j]==1.0){
					result[i][j]=a[i][j]-mean[j];
				}
			}
		}
		return result;
	}
	
}
class TextFileRead {
	private String inputFile;
    public HashMap<Integer, String> movie_ids=new HashMap<Integer,String>();

   public void setInputFile(String inputFile) {
            this.inputFile = inputFile;
   }
 
    public HashMap<Integer, String> fileRead() {
    	ArrayList<String> Sentence_Collection = new ArrayList<String>();    	
    	
        try {
            FileReader reader = new FileReader(this.inputFile);
            BufferedReader bufferedReader = new BufferedReader(reader);
 
            String line;
 
            while ((line = bufferedReader.readLine()) != null) {
       
            	Sentence_Collection.add(line);
            	
            	
            	  }
            
            for (String Sentence : Sentence_Collection) {
            	String[] splitS=Sentence.split(" ", 2);
            	int j=Integer.parseInt(splitS[0]);
        		this.movie_ids.put(j,splitS[1]);
        	}
            
            reader.close();
 
        } catch (IOException e) {
            e.printStackTrace();
        }
		return this.movie_ids;
    }
 
}

class ReadExcel {

    private String inputFile;
    public double[][] ratingData;

   // public void setInputFile(String inputFile) {
   //         this.inputFile = inputFile;
  //  }

    public double[][] read() throws IOException  {
            File inputWorkbook = new File(inputFile);
            Workbook w;
            try {
                    w = Workbook.getWorkbook(inputWorkbook);
                   
                    Sheet sheet = w.getSheet(0);
                
                    ratingData = new double[sheet.getRows()][sheet.getColumns()];
                    for (int j = 0; j < sheet.getColumns(); j++) {
                            for (int i = 0; i < sheet.getRows(); i++) {
                                    Cell cell = sheet.getCell(j, i);
                                    ratingData[i][j]=Double.parseDouble(cell.getContents());


                            }
                    }
            } catch (BiffException e) {
                    e.printStackTrace();
            }
            return ratingData;
    }
    public double[][] fetchData(double[][] a, HashMap <String,String> c, int row, int col ){
    	int i=0,j=0,colLength=0,rowLength=0;
    	
    	double[][] ratings;
    	for (String key : c.keySet()) {
    		this.inputFile = c.get(key);
    		
    		try {
				ratings=this.read();
				rowLength=ratings.length;
				colLength=ratings[0].length;
				for (int y=0;y<colLength;y++){
					for (int x=0;x<rowLength;x++)
					{
						a[x][j+y]=ratings[x][y];
					}
					
				}
				j=j+colLength;
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		
    		
    	}
    	return a;
    }
  }

class Initialize{
	public HashMap<String, String> R_init(){
		HashMap<String,String> pathR= new HashMap<String, String>();
		pathR.put("rating1", "Data/MovieRatings.xls");
		return pathR;
	}
	public HashMap<String, String> RB_init(){
		HashMap<String,String> pathRB= new HashMap<String, String>();
		pathRB.put("rating_binary_1", "Data/MovieRatings_Binary.xls");
		return pathRB;
	}
}
public class UserUserRec {

	public static void main(String[] args) {
		int numUsers=26; //including the current user
		int numMovies=100; //total no. of movies in repository 
		double[][] ratingData =new double[numMovies][numUsers];
		double[][] ratingData_binary =new double[numMovies][numUsers];
		Initialize init=new Initialize();
		ReadExcel read_xls = new ReadExcel();
		HashMap<String,String> pathR= new HashMap<String, String>();
		HashMap<String,String> pathRB= new HashMap<String, String>();
		pathR=init.R_init();
		pathRB=init.RB_init();
		ratingData=read_xls.fetchData(ratingData, pathR, numMovies, numUsers);
		ratingData_binary=read_xls.fetchData(ratingData_binary, pathRB, numMovies, numUsers);        
		TextFileRead textfile=new TextFileRead();
        textfile.setInputFile("Data/Movie_IdsAndNames.txt");
        HashMap<Integer,String> movie_ids=textfile.fileRead();
		Scanner in=new Scanner(System.in);
		System.out.println("Hello User, Please enter your rating for the movies inorder to create your recommendation. "
				+ "First tell me how many movies you are gonna rate today and then go though the List of Movies and "
				+"then enter your rating(1-5) for a particular movie alongside of its Serial Number. All the data you enter should be "
				+"should be followed by a space.");
        int j=in.nextInt();
        int index=0;
        double rating=0;
        for (int i=0; i<j; i++)
        {
        	index=in.nextInt();
        	rating=in.nextDouble();
        	System.out.println("Movie: "+movie_ids.get(index) + " Rating: "+ rating);
        	ratingData[index-1][25]=rating;
        	ratingData_binary[index-1][25]=1.0;
        }
        
        Normalization norm=new Normalization();
        double[] mean=norm.MeanCalc(ratingData, ratingData_binary, numMovies, numUsers);
        double[][] ratingData_norm=norm.RatingNormalize(ratingData, ratingData_binary, numMovies, numUsers, mean);
        correlation corr=new correlation();
        TreeMap<Double, Integer> neighbours=corr.Neighbours(ratingData_norm,ratingData_binary , numMovies, numUsers);
        
        Set set = neighbours.entrySet();
        Iterator it = set.iterator();
        System.out.println("Top 10 neighbours for you!!!");
        for(int i=0;i<10;i++)
        {
        	Map.Entry me = (Map.Entry)it.next();
            System.out.print("Correlation is: "+new DecimalFormat("##.######").format(me.getKey()) + " & ");
            System.out.println("Neighbour is: "+me.getValue());
        }
        Prediction pred=new Prediction();
        TreeMap<Double, Integer> score=pred.PredictScore(ratingData_norm,ratingData_binary,mean[25],neighbours,numMovies,numUsers);
        Set set1 = score.entrySet();
        Iterator it1 = set1.iterator();
        System.out.println("Top 10 Movies for you!!!");
        for(int i=0;i<10;i++)
        {
        	Map.Entry me1 = (Map.Entry)it1.next();
            System.out.print("Score is: "+new DecimalFormat("##.##").format(me1.getKey()) + " & ");
            System.out.print("MovieID is: "+((int)me1.getValue()+1)+ " & ");
            System.out.println("Movie is: " +movie_ids.get((int)me1.getValue()+1));
        }
        
        
	}

}
