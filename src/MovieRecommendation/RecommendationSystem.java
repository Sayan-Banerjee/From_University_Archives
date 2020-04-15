package MovieRecommendation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeMap;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import java.lang.*;
import java.text.DecimalFormat;
class Recommendation{
	MatrixOperations matrix_opr=new MatrixOperations();
	public double[] prediction(double[][] X, double[][] theta, double[][] ratingData_binary, double[] means, int[] viewerCount){
		double[] result= new double[ratingData_binary.length];
		double[][] theta_tran=matrix_opr.transpose(theta, theta.length, theta[0].length);
		double[][] pred=matrix_opr.matrixMul(X, theta_tran, X.length, X[0].length, theta_tran.length, theta_tran[0].length);
		for (int i=0; i<ratingData_binary.length;i++ )
		{
			if(ratingData_binary[i][943]==0.0&&viewerCount[i]>=10)
			{
				result[i]=pred[i][943]+means[i];
			}
			else 
			{
				result[i]=0.0;
			}
		}
		return result;
	}
	public TreeMap<Double,String> TopRec(HashMap<Integer,String> movie_ids,double[] result)
	{
		TreeMap<Double, String> treemap = new TreeMap<Double, String>(Collections.reverseOrder());
		for (int i=0; i<result.length; i++)
		{
			String m=movie_ids.get(i+1);
			treemap.put(result[i], m);
		}
		return treemap;
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


class MatrixOperations{
	
	public double[][] transpose(double[][] a, int row, int col)
	{
		double[][] a_t=new double[col][row];
		for(int i=0;i<row;i++){
			for (int j=0; j<col;j++){
				a_t[j][i]=a[i][j];
			}
		}
	
		return a_t;
	}
	public double[][] matrixMul(double[][] a, double[][] b, int row1, int col1, int row2, int col2)
	{
		double[][] result=new double[row1][col2];
		double cal=0;
		for(int i=0; i<row1;i++)
		{
			for (int j=0; j<col2;j++)
			{
				cal=0;
				for (int p=0,q=0;p<col1&&q<row2;p++,q++)
				{
					cal=cal+a[i][p]*b[q][j];
				}
				result[i][j]=cal;
			}
		}
		
		return result;
	}
	public double[][] elementWiseMul(double[][] a, double[][] b, int row, int col)
	{
		double[][] result=new double[row][col];
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result[i][j]=a[i][j]*b[i][j];
			}
		}
		return result;
	}
	public double[][] scalerMul(double[][] a,int row, int col, double scaler)
	{
		double[][] result=new double[row][col];
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result[i][j]=a[i][j]*scaler;
			}
		}
		return result;
	}
	public double addAllElements(double[][] a, int row, int col)
	{
		double result=0.0;
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result=result+a[i][j];
			}
		} 
		return result;
		
	}
	public double[][] elementWiseDiff(double[][] a, double[][] b, int row, int col)
	{
		double[][] result=new double[row][col];
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result[i][j]=a[i][j]-b[i][j];
			}
		}
		return result;
	}
	
	public double[][] elementWisePow(double[][] a,int row, int col, int power)
	{
		double[][] result=new double[row][col];
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result[i][j]=Math.pow(a[i][j], power);
			}
		}
		return result;
	}
	public double[][] elementWiseAdd(double[][] a, double[][] b, int row, int col)
	{
		double[][] result=new double[row][col];
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				result[i][j]=a[i][j]+b[i][j];
			}
		}
		return result;
	}
	
	
}
class Normalization{
	public int[] viewCount(double[][] a, int row, int col){
		int[] countViewers = new int[row];
		int count=0;
		for (int i=0; i<row; i++)
		{
			for (int j=0; j<col; j++)
			{
				if(a[i][j]==1.0)
				{
					count=count+1;
				}
			}
			countViewers[i]=count;
			count=0;
		}
		return countViewers;
	}
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
class Optimization{
	MatrixOperations matrix_op=new MatrixOperations();
	public double CostCalc(double[][] error, double[][] X, double[][] theta, double lambda){
		double cost=0.0;
		double[][] cost_calc=matrix_op.elementWisePow(error,error.length,error[0].length, 2);
		double [][] X_pow=matrix_op.elementWisePow(X,X.length,X[0].length,2);
		double [][] theta_pow=matrix_op.elementWisePow(theta,theta.length,X[0].length,2);
		cost=matrix_op.addAllElements(cost_calc, cost_calc.length, cost_calc[0].length);
		cost=cost/2;
		double X_sum=matrix_op.addAllElements(X_pow,X_pow.length,X_pow[0].length);
		double theta_sum=matrix_op.addAllElements(theta_pow,theta_pow.length,theta_pow[0].length);
		cost=cost+((lambda/2)*X_sum)+((lambda/2)*theta_sum);
		return cost;
				
	}
	
	public HashMap<String, double[][]> GradientDescent(double[][] ratingData_norm, double[][] ratingData_binary, double[][] theta, double[][] X, int iter, double alpha, double lambda)
	{
		HashMap<String, double[][]> result= new HashMap<String, double[][]>();
		
		double[][] theta_tran=new double[theta[0].length][theta.length];
		double[][] theta_grad=new double[theta.length][theta[0].length];
		//double[][] X_tran=new double[X[0].length][X.length]();
		double[][] X_grad=new double[X.length][X[0].length];
		double[][] hypothesis=new double[ratingData_norm.length][ratingData_norm[0].length];
		double[][] error=new double[ratingData_norm.length][ratingData_norm[0].length];
		double[][] error_tran=new double[ratingData_norm[0].length][ratingData_norm.length];
		double cost=0;
		for (int i=0; i<iter; i++)
		{
			theta_grad=matrix_op.scalerMul(theta_grad,theta_grad.length,theta_grad[0].length,alpha);
			X_grad=matrix_op.scalerMul(X_grad,X_grad.length,X_grad[0].length,alpha);
			theta=matrix_op.elementWiseDiff(theta,theta_grad,theta.length,theta[0].length);
			X=matrix_op.elementWiseDiff(X,X_grad,X.length,X[0].length);
			theta_tran=matrix_op.transpose(theta,theta.length,theta[0].length);
			//X_tran=matrix_op.transpose(X,X.length,X[0].length);
			hypothesis=matrix_op.matrixMul(X,theta_tran,X.length,X[0].length,theta_tran.length,theta_tran[0].length);
			error=matrix_op.elementWiseDiff(hypothesis,ratingData_norm,hypothesis.length,hypothesis[0].length);
			error=matrix_op.elementWiseMul(error,ratingData_binary,error.length,error[0].length);
			cost=CostCalc(error,X,theta,lambda);
			System.out.println(cost);
			X_grad=matrix_op.matrixMul(error,theta,error.length,error[0].length,theta.length,theta[0].length);
			X_grad=matrix_op.elementWiseAdd(X_grad,matrix_op.scalerMul(X,X.length,X[0].length,lambda),X_grad.length,X_grad[0].length);
			error_tran=matrix_op.transpose(error,error.length,error[0].length);
			theta_grad=matrix_op.matrixMul(error_tran,X,error_tran.length,error_tran[0].length,X.length,X[0].length);
			theta_grad=matrix_op.elementWiseAdd(theta_grad,matrix_op.scalerMul(theta,theta.length,theta[0].length,lambda),theta_grad.length,theta_grad[0].length);
			
			
			
			
		}
		result.put("Optimized_X",X);
		result.put("Optimized_theta",theta);
		return result;
		
		
		
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
    	//Set<String> keys = c.keySet();
    	//String[] keyArray = (String[]) keys.toArray();
    	for (String key : c.keySet()) {
    		this.inputFile = c.get(key);
    		//System.out.println(this.inputFile);
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
	public double[][] random_init(double[][] a, int row, int col)
	{
		Random randomGenerator = new Random();
		for (int i=0;i<row;i++)
		{
			for (int j=0;j<col;j++)
			{
				a[i][j]=randomGenerator.nextGaussian();
			}
		}
		return a;
	}
	public HashMap<String, String> R_init(){
		HashMap<String,String> pathR= new HashMap<String, String>();
		pathR.put("rating1", "Data/rating1.xls");
		pathR.put("rating2", "Data/rating2.xls");
		pathR.put("rating3", "Data/rating3.xls");
		pathR.put("rating4", "Data/rating4.xls");
		return pathR;
	}
	public HashMap<String, String> RB_init(){
		HashMap<String,String> pathRB= new HashMap<String, String>();
		pathRB.put("rating_binary_1", "Data/rating_binary_1.xls");
		pathRB.put("rating_binary_2", "Data/rating_binary_2.xls");
		pathRB.put("rating_binary_3", "Data/rating_binary_3.xls");
		pathRB.put("rating_binary_4", "Data/rating_binary_4.xls");
		return pathRB;
	}
}
public class RecommendationSystem {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int iter=1000;
		double alpha=0.003;
		int lambda=10;
		int numUsers=944; //including the current user
		int numMovies=1682; //total no. of movies in repository 
		int features =10; // taking each movie has 10 features each, Ex.: Romantic, Action etc.
		double[][] ratingData =new double[numMovies][numUsers];
		//Arrays.fill(ratingData,new Double(0.0));
		double[][] ratingData_binary =new double[numMovies][numUsers];
		//Arrays.fill(ratingData_binary,new Double(0.0));
		double[][] theta=new double[numUsers][features];
		Initialize init=new Initialize();
		theta=init.random_init(theta, numUsers, features);
		double[][] X= new double[numMovies][features];
		X=init.random_init(X, numMovies, features);
		ReadExcel read_xls = new ReadExcel();
		HashMap<String,String> pathR= new HashMap<String, String>();
		HashMap<String,String> pathRB= new HashMap<String, String>();
		pathR=init.R_init();
		pathRB=init.RB_init();
		ratingData=read_xls.fetchData(ratingData, pathR, numMovies, numUsers);
		ratingData_binary=read_xls.fetchData(ratingData_binary, pathRB, numMovies, numUsers);        
        //System.out.println(ratingData[1139][943]);
		TextFileRead textfile=new TextFileRead();
        textfile.setInputFile("Data/movie_ids.txt");
        HashMap<Integer,String> movie_ids=textfile.fileRead();
		Scanner in=new Scanner(System.in);
		System.out.println("Hello User, Please enter your rating for the movies inorder to create your recommendation. "
				+ "First tell me how many movies you are gonna rate today and then go though the List of Movies and "
				+"then enter your rating(1-5) for a particular movie alongside of its id. All the data you enter should be "
				+"should be followed by a space.");
        int j=in.nextInt();
        int index=0,rating=0;
        for (int i=0; i<j; i++)
        {
        	index=in.nextInt();
        	rating=in.nextInt();
        	System.out.println("Movie: "+movie_ids.get(index) + " Rating: "+ rating);
        	ratingData[index-1][943]=(double)rating;
        	ratingData_binary[index-1][943]=1.0;
        }
        Normalization norm=new Normalization();
        double[] mean=norm.MeanCalc(ratingData, ratingData_binary, numMovies, numUsers);
        double[][] ratingData_norm=norm.RatingNormalize(ratingData, ratingData_binary, numMovies, numUsers, mean);
        int[] viewerCount=norm.viewCount(ratingData_binary, ratingData_binary.length, ratingData_binary[0].length);
        Optimization opt=new Optimization();
        HashMap<String, double[][]> optimized= opt.GradientDescent(ratingData_norm, ratingData_binary, theta, X, iter, alpha, lambda);
        double[][] opt_X=optimized.get("Optimized_X");
        double[][] opt_theta=optimized.get("Optimized_theta");
        Recommendation rec=new Recommendation();
        double[] result=rec.prediction(opt_X, opt_theta, ratingData_binary, mean, viewerCount);
        System.out.println(java.util.Arrays.toString(result));
        TreeMap<Double,String> topRec=rec.TopRec(movie_ids, result);
        Set set = topRec.entrySet();
        Iterator it = set.iterator();
        System.out.println("Top 10 Recommendation for you!!!");
        for(int i=0;i<10;i++)
        {
        	Map.Entry me = (Map.Entry)it.next();
            System.out.print("Rating is: "+new DecimalFormat("##.##").format(me.getKey()) + " & ");
            System.out.println("Movie is: "+me.getValue());
        }
        
        

        

	}

}
