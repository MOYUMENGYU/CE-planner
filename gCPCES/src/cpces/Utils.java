package cpces;

import com.hstairs.ppmajal.conditions.PDDLObject;
import com.hstairs.ppmajal.conditions.Predicate;
import com.hstairs.ppmajal.problem.EPddlProblem;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;

public class Utils {
    public static void saveproblem (String problemSampleFile, EPddlProblem pp) throws IOException {

        pp.setPddlFilRef(problemSampleFile);
        Writer file = new BufferedWriter(new FileWriter(problemSampleFile));
        StringBuilder builder = new StringBuilder();
        builder.append(pp.getDomainName()).append(")");
        file.write("(define (problem temp)");
        file.write("(:domain ");
        file.write(builder.toString());
        file.write(pp.getObjects().pddlPrint());

        final StringBuilder ret = new StringBuilder("(:init (true)\n");
        CPCES_State state = (CPCES_State)pp.getInit();
        for (Predicate a : state.getPredicates()) {
                ret.append("  (").append(a.getPredicateName());
                for (Object o1 : a.getTerms()) {
                    PDDLObject obj = (PDDLObject) o1;
                    ret.append(" ").append(obj.getName());
                }
                ret.append(")\n");
        }
        ret.append(")\n");

        file.write(ret.toString());
        file.write("(:goal (forall (?interpr - interpretation)");
        file.write(pp.getGoals().pddlPrintWithExtraObject() + ")))");
        file.close();
    }
}
