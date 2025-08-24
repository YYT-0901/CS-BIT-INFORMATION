import java.io.*;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class Inspection {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage: java Inspection <input> <output>");
            System.exit(1);
        }

        try {
            inspect(args[0], args[1]);
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }

    private static void inspect(String inputPath, String outputPath) throws IOException {
        Map<String, Integer> labelCounts = new HashMap<>();
        int total = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(inputPath))) {
            reader.readLine();

            String line;
            while ((line = reader.readLine()) != null) {
                String[] columns = line.split("\t");
                if (columns.length == 0) continue;
                String label = columns[columns.length - 1];
                labelCounts.put(label, labelCounts.getOrDefault(label, 0) + 1);
                total++;
            }
        }

        if (total == 0) {
            writeResults(outputPath, 0.0, 0.0);
            return;
        }

        // 计算熵
        double entropy = 0.0;
        for (int count : labelCounts.values()) {
            double p = (double) count / total;
            if (p > 0) {
                entropy -= p * (Math.log(p) / Math.log(2));
            }
        }

        // 计算错误率
        int maxCount = Collections.max(labelCounts.values());
        double errorRate = 1.0 - ((double) maxCount / total);

        writeResults(outputPath, entropy, errorRate);
    }

    private static void writeResults(String path, double entropy, double error) throws IOException {
        try (PrintWriter writer = new PrintWriter(new FileWriter(path))) {
            writer.printf("entropy: %.12f%n", entropy);
            writer.printf("error: %.12f%n", error);
        }
    }
}