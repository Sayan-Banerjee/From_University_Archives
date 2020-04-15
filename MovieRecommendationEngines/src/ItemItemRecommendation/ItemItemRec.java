package ItemItemRecommendation;

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
	public TreeMap<Double, Integer> Recommendation(double[][]a, double[][] b, double[] mean, double[][] corr, int row, int col) 
	{
		TreeMap<Double, Integer> score = new TreeMap<Double, Integer>(Collections.reverseOrder());
		double[] predict=new double[row];
		predict=PredictScore(a,b,mean,corr,row, col);
		for(int i=0; i< row; i++)
		{
			score.put(predict[i], i);
		}
		return score;
	}
	double[] PredictScore(double[][]a, double[][] b, double[] mean, double[][] corr, int row, int col)
	{
		double[] predict=new double[row];
		for(int i=0; i< row; i++)
		{
			if(b[i][25]!=0.0)
			{
				predict[i]=0.0;
			}
			else
			{
				double score=0.0;
				double weight=0.0;
				for(int j=0; j< row; j++)
				{
					if(b[j][25]!=0)
					{
						score=score+(corr[i][j]*a[j][25]);
						weight=weight+corr[i][j];
					}
				}
				score=score/weight;
				score=score+mean[i];
				predict[i]=score;
			}
		}
		return predict;
	}
}
class Correlation{
	double[] normCalc(double[][] a, double[][] b, int row, int col)
	{
		double[] norms= new double[row];
		for(int i=0; i< row; i++)
		{  double norm=0.0;
			for(int j=0; j< col; j++)
			{
				if (b[i][j]==1.0)
				{
				norm=norm+Math.pow(a[i][j], 2);
				}
			}
			norm=Math.sqrt(norm);
			norms[i]=norm;
		}
		return norms;
	}
	public double[][] CorrCalc(double[][] a, double[][] b, int row, int col)
	{
		double[][] corr= new double[row][row];
		double[] norms=normCalc(a,b,row,col);
		double numerator=0.0;
		double weight=0.0;
		for (int i=0; i< row; i++)
		{
			for(int j=0; j< row; j++)
			{
				numerator=numeratorCalc(a,b,col,i,j);
				weight=numerator/(norms[i]*norms[j]);
				corr[i][j]=weight;
				weight=0.0;
				numerator=0.0;
				
			}
		}
		for (int i=0; i< row; i++)
		{
			for(int j=0; j< row; j++)
			{
				if(corr[i][j]<0)
				{
					corr[i][j]=0;
				}
			}
		}	
		return corr;
	}
	double numeratorCalc(double[][] a, double[][] b, int col, int item1, int item2)
	{
		double numerator=0.0;
		for(int i=0; i< col; i++)
		{
			if(b[item1][i]!=0.0 && b[item2][i]!=0.0)
			{
				numerator=numerator+(a[item1][i]*a[item2][i]);
			}
		}
		return numerator;
	}
}
class Normalization{
	public double[] MeanCalc(double[][] a, double[][] b, int row, int col){
		double[] meanRating=new double[row];
		int counter=0;
		double sum=0.0;
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				if (b[i][j]==1.0){
					counter=counter+1;
					sum=sum+a[i][j];
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
		for (int i=0; i<row; i++){
			for (int j=0; j<col; j++){
				if (b[i][j]==1.0){
					result[i][j]=a[i][j]-mean[i];
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
public class ItemItemRec {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
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
        Correlation correlation=new Correlation();
        double[][] corr=correlation.CorrCalc(ratingData_norm, ratingData_binary, numMovies, numUsers);
        Prediction pred=new Prediction();
        TreeMap<Double, Integer> rec=pred.Recommendation(ratingData_norm, ratingData_binary, mean, corr, numMovies, numUsers);
        Set set1 = rec.entrySet();
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
