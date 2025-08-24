import java.util.HashMap;
import java.util.Map;

/*
 * 决策树结构
 * */
public class TreeNode {
    String attribute;
    String label;
    Map<String, TreeNode> children;
    Map<String, Integer> classCounts;

    TreeNode(String attribute) {
        this.attribute = attribute;
        this.children = new HashMap<>();
    }

    TreeNode(String label, Map<String, Integer> classCounts) {
        this.label = label;
        this.classCounts = classCounts;
    }

    boolean isLeaf() {
        return label != null;
    }

    public String getAttribute() {
        return attribute;
    }

    public void setAttribute(String attribute) {
        this.attribute = attribute;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public Map<String, TreeNode> getChildren() {
        return children;
    }

    public void setChildren(Map<String, TreeNode> children) {
        this.children = children;
    }

    public Map<String, Integer> getClassCounts() {
        return classCounts;
    }

    public void setClassCounts(Map<String, Integer> classCounts) {
        this.classCounts = classCounts;
    }
}