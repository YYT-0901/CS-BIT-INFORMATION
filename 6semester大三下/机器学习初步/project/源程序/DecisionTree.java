import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class DecisionTree {
    public static void main(String[] args) {
        if (args.length != 6) {
            System.err.println("Usage: java decisionTree <train_input> <test_input> <max_depth> <train_out> <test_out> <metrics_out>");
            System.exit(1);
        }

        String trainInputPath = args[0];
        String testInputPath = args[1];
        int maxDepth = Integer.parseInt(args[2]);
        String trainOutputPath = args[3];
        String testOutputPath = args[4];
        String metricsOutputPath = args[5];

        try {
            List<List<String>> trainData = readTSV(trainInputPath);
            List<List<String>> testData = readTSV(testInputPath);

            List<String> headers = new ArrayList<>(trainData.get(0));
            trainData.remove(0);
            testData.remove(0);

            TreeNode root = buildTree(trainData, headers, maxDepth, 0);
            printTree(root, headers, 0, "", "");

            List<String> trainLabels = getLabels(trainData);
            List<String> testLabels = getLabels(testData);

            List<String> trainPredictions = predict(trainData, headers, root);
            List<String> testPredictions = predict(testData, headers, root);

            writeLabels(trainOutputPath, trainPredictions);
            writeLabels(testOutputPath, testPredictions);

            double trainError = calculateError(trainLabels, trainPredictions);
            double testError = calculateError(testLabels, testPredictions);
            writeMetrics(metricsOutputPath, trainError, testError);

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }

    // ---------- 核心方法 ----------
    static TreeNode buildTree(List<List<String>> data, List<String> headers, int maxDepth, int currentDepth) {
        Map<String, Integer> classCounts = getClassCounts(data);
        if (classCounts.size() == 1 || currentDepth >= maxDepth) {
            return new TreeNode(getMajorityClass(classCounts), classCounts);
        }

        int bestAttrIndex = selectBestAttribute(data, headers);
        if (bestAttrIndex == -1) {
            return new TreeNode(getMajorityClass(classCounts), classCounts);
        }

        String bestAttr = headers.get(bestAttrIndex);
        TreeNode node = new TreeNode(bestAttr);
        node.classCounts = classCounts;

        Map<String, List<List<String>>> splits = new HashMap<>();
        for (List<String> row : data) {
            String attrValue = row.get(bestAttrIndex);
            splits.computeIfAbsent(attrValue, k -> new ArrayList<>()).add(row);
        }

        for (Map.Entry<String, List<List<String>>> entry : splits.entrySet()) {
            String attrValue = entry.getKey();
            List<List<String>> subset = entry.getValue();
            node.children.put(attrValue, buildTree(subset, headers, maxDepth, currentDepth + 1));
        }

        return node;
    }

    static int selectBestAttribute(List<List<String>> data, List<String> headers) {
        double maxMI = 0;
        int bestAttrIndex = -1;
        double classEntropy = calculateClassEntropy(data);

        for (int i = 0; i < headers.size() - 1; i++) {
            double attrMI = calculateMutualInformation(data, i, classEntropy);
            if (attrMI > maxMI) {
                maxMI = attrMI;
                bestAttrIndex = i;
            }
        }

        return maxMI > 0 ? bestAttrIndex : -1;
    }

    // ---------- 工具函数 ----------
    static double calculateMutualInformation(List<List<String>> data, int attrIndex, double classEntropy) {
        Map<String, List<List<String>>> splits = new HashMap<>();
        for (List<String> row : data) {
            String attrValue = row.get(attrIndex);
            splits.computeIfAbsent(attrValue, k -> new ArrayList<>()).add(row);
        }

        double conditionalEntropy = 0;
        for (List<List<String>> subset : splits.values()) {
            double p = (double) subset.size() / data.size();
            conditionalEntropy += p * calculateClassEntropy(subset);
        }

        return classEntropy - conditionalEntropy;
    }

    static double calculateClassEntropy(List<List<String>> data) {
        Map<String, Integer> classCounts = getClassCounts(data);
        double entropy = 0;
        for (int count : classCounts.values()) {
            double p = (double) count / data.size();
            entropy -= p * Math.log(p) / Math.log(2);
        }
        return entropy;
    }

    static Map<String, Integer> getClassCounts(List<List<String>> data) {
        Map<String, Integer> counts = new HashMap<>();
        int classIndex = data.get(0).size() - 1;
        for (List<String> row : data) {
            String className = row.get(classIndex);
            counts.put(className, counts.getOrDefault(className, 0) + 1);
        }
        return counts;
    }

    static String getMajorityClass(Map<String, Integer> classCounts) {
        return classCounts.entrySet().stream()
                .sorted((e1, e2) -> e2.getValue() != e1.getValue() ?
                        e2.getValue() - e1.getValue() :
                        e2.getKey().compareTo(e1.getKey()))
                .findFirst()
                .get()
                .getKey();
    }

    // ---------- 预测与输出 ----------
    static List<String> predict(List<List<String>> data, List<String> headers, TreeNode root) {
        return data.stream()
                .map(row -> predictRow(row, headers, root))
                .collect(Collectors.toList());
    }

    static String predictRow(List<String> row, List<String> headers, TreeNode node) {
        if (node.isLeaf()) {
            return node.label;
        }

        int attrIndex = headers.indexOf(node.attribute);
        String attrValue = row.get(attrIndex);
        TreeNode child = node.children.get(attrValue);

        return (child != null) ? predictRow(row, headers, child) : getMajorityClass(node.classCounts);
    }

    static void printTree(TreeNode node, List<String> headers, int depth, String parentAttr, String parentValue) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < depth; i++) sb.append("| ");
        if (depth > 0) sb.append(parentAttr).append(" = ").append(parentValue).append(": ");
        sb.append("[").append(
                node.classCounts.entrySet().stream()
                        .map(e -> e.getValue() + " " + e.getKey())
                        .collect(Collectors.joining("/"))
        ).append("]");
        System.out.println(sb);

        if (!node.isLeaf()) {
            node.children.forEach((value, child) ->
                    printTree(child, headers, depth + 1, node.attribute, value));
        }
    }

    static List<List<String>> readTSV(String filePath) throws IOException {
        List<List<String>> data = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                data.add(Arrays.asList(line.split("\t")));
            }
        }
        return data;
    }

    static List<String> getLabels(List<List<String>> data) {
        int classIndex = data.get(0).size() - 1;
        return data.stream().map(row -> row.get(classIndex)).collect(Collectors.toList());
    }

    static void writeLabels(String filePath, List<String> labels) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (String label : labels) bw.write(label + "\n");
        }
    }

    static double calculateError(List<String> trueLabels, List<String> predictedLabels) {
        int errors = 0;
        for (int i = 0; i < trueLabels.size(); i++) {
            if (!trueLabels.get(i).equals(predictedLabels.get(i))) errors++;
        }
        return (double) errors / trueLabels.size();
    }

    static void writeMetrics(String filePath, double trainError, double testError) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            bw.write(String.format("error(train): %.6f\n", trainError));
            bw.write(String.format("error(test): %.6f\n", testError));
        }
    }
}