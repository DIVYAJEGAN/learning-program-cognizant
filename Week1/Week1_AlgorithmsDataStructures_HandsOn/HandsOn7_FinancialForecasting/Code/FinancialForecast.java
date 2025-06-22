
public class FinancialForecast {

    
    public static double predictFutureValue(double initialValue, double rate, int years) {
        if (years == 0) {
            return initialValue; 
        } else {
            return predictFutureValue(initialValue, rate, years - 1) * (1 + rate);
        }
    }

    public static void main(String[] args) {
        double initialValue = 10000; 
        double growthRate = 0.07;    
        int years = 5;              
        double futureValue = predictFutureValue(initialValue, growthRate, years);
        System.out.printf("Predicted value after %d years: INR %.2f\n", years, futureValue);

    }
}
