/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import com.hstairs.ppmajal.domain.PddlDomain;
import com.hstairs.ppmajal.plan.SimplePlan;
import com.hstairs.ppmajal.problem.EPddlProblem;
import com.hstairs.ppmajal.wrapped_planners.madagascarWrapper;
import com.hstairs.ppmajal.wrapped_planners.metricFFWrapper;
import com.hstairs.ppmajal.wrapped_planners.planningTool;
import cpces.*;
import org.apache.commons.cli.*;

import java.io.File;
import java.net.URISyntaxException;


/**
 *
 * @author Enrico Scala
 */
public class main {

    private static String domainFile;
    private static String problemFile;
    private static String cp;
    private static String ref;
    private static int debug;
    private static int ub;
    private static long samplingTime = 0;
    private static long cpTime = 0;
    private static long confPTime = 0;
    private static int iteration = 0;
    private static int lastSampleCardinality = 0;
    private static String ffPath ;
    private static String mpcPath;
    private static String hffPath;
    private static String pm;
    private static boolean unbreakable;
    private static String ip;
    private static String op;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        parseArgument(args);
        try {
            ffPath = new File(main.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getParent()+"/ff";
            mpcPath = new File(main.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getParent()+"/MpC";
            hffPath = new File(main.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getParent()+"/hFF";
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        long start = System.nanoTime();
        SimplePlan p = conformantPlanning();
        if (op != null){
            p.savePlan(op);
        }
        confPTime += System.nanoTime()-start;
        printStats(p);
    }

   

    
    static private SimplePlan conformantPlanningCPCES(PddlDomain domain, EPddlProblem problem, PlanGenerator pgen, SampleGenerator sgen) {
        SimplePlan candidatePlan = new SimplePlan(domain, problem);

        if (ip != null){
            try {
                candidatePlan.parseSolution(ip);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        for (;;) {
            if (iteration > ub)
                return null;
            System.out.println("Iteration: "+iteration++);
            long start;
            
            {//Sampling 
                start = System.nanoTime();
                boolean ceFound = sgen.refineCPCESSample(candidatePlan);
                samplingTime += System.nanoTime()-start;
                if (debug > 0) System.out.println(sgen.lastSMTFormula);
                if (!ceFound) {//return true if at least a counterexample is found
                    return candidatePlan;
                }
                
                if (sgen instanceof GreedySampleGenerator)
                    lastSampleCardinality = iteration;
                else
                    lastSampleCardinality = sgen.getCPCESSample().size();
                System.out.println("|S|:"+lastSampleCardinality);
            }
            pgen.refineCPInitialCPCESStates(sgen.getCPCESSample());//this creates an explicit belief representation
            
            {//Planning
                start = System.nanoTime();
                candidatePlan = pgen.computePlan();//this is a classical planning call
                cpTime += System.nanoTime()-start;
                System.out.println("Classical Planner Time: "+(float)pgen.p.getPlannerTime()/1000f+"s");
                
            }
            
            if (candidatePlan == null) {
                System.out.println("Unsolvable");
                System.out.println("Counterexamples-set:"+sgen.getCPCESSample());
                return null;
            } 
            if (debug > 0) System.out.println(candidatePlan);
        }
    }

    static public SimplePlan conformantPlanning() {
        final SampleGenerator sgen;
        final PlanGenerator pgen1;
//        PlanGenerator pgen1;
        final PddlDomain domain = new PddlDomain(domainFile);
        System.out.println("Domain parsed");
        final EPddlProblem problem = new EPddlProblem(problemFile, domain.getConstants(),domain.getTypes());
        domain.validate(problem);
        planningTool p = setPlanningTool(cp);
        if (ref.equalsIgnoreCase("refined")) { // probably needs more parameters in the constructors
            sgen = new RefinedSampleGenerator(problem.belief, problem.getGoals());
            if (pm.contains("macro")){
                System.out.println("Macro Generator");
                pgen1 = new MacroScratchPlanGenerator(domain,problem,p);
            }else {
                pgen1 = new ScratchPlanGenerator(domain, problem, p);
            }
        } else if (ref.equalsIgnoreCase("heuristic")){
            if (pm.contains("macro")){
                pgen1 = new MacroScratchPlanGenerator(domain,problem,p);
            }else {
                pgen1 = new ScratchPlanGenerator(domain, problem, p);
            }
            sgen = new HeuristicRefineSampleGenerator(problem.belief, problem.getGoals(), new ScratchPlanGenerator(domain, problem,setPlanningTool("hff")));
        } else {
            sgen = new GreedySampleGenerator(problem.belief,problem.getGoals());
            if (pm.contains("macro")){
                pgen1 = new MacroIncrementalPlanGenerator(domain,problem,p);
            }else {
                pgen1 = new IncrementalPlanGenerator(domain, problem, p);
            }
        }

        final SimplePlan result = conformantPlanningCPCES(domain, problem, pgen1, sgen);
        return result;
    }

    public static planningTool setPlanningTool(String cp) {
        planningTool p = null;
        if (cp == null || "ff".equals(cp.toLowerCase())) {
            p = new metricFFWrapper();
            p.setPlanningExec(ffPath);
        } else if ("mpc".equals(cp.toLowerCase())) {
            p = new madagascarWrapper();
            p.setPlanningExec(mpcPath);
        }else if ("hff".equals(cp.toLowerCase())) {
            p = new metricFFWrapper();
            p.setPlanningExec(hffPath);
        } else {
            p = new metricFFWrapper();
            p.setPlanningExec(ffPath);
        }
        p.setTimeout(3600000);///1 hour of timeout. Time here is given in msec
//        p.prefixParameters = "ulimit -m 8096000";

        return p;
    }

    private static void parseArgument(String[] args) {
        Options options = new Options();
        try {
            options.addRequiredOption("o", "domain", true, "PDDL domain file");
            options.addRequiredOption("f", "problem", true, "PDDL problem file");
            options.addOption("cp", "classical planner", true, "Classical Planner. Select from {ff,mpc}");
            options.addOption("ref", "sampling method", true, "Sampling method {greedy,refined}");
            options.addOption("pm", "planning method", true, "Planning method {replanning,macro}");
            options.addOption("debug", "debug level", true, "");
            options.addOption("ub", "upper bound on number of iterations", true, "");
            options.addOption("ip", "input_plan", true, "Provide a plan in input to start the conformant planning from");
            options.addOption("op", "output_plan", true, "Save the plan to the input filename");

            CommandLineParser parser = new DefaultParser();
            CommandLine cmd = parser.parse(options, args);
            domainFile = cmd.getOptionValue("o");
            problemFile = cmd.getOptionValue("f");
            cp = cmd.getOptionValue("cp");
            debug = (cmd.getOptionValue("debug") != null) ? Integer.parseInt(cmd.getOptionValue("debug")) : 0;
            ub = (cmd.getOptionValue("ub") != null) ? Integer.parseInt(cmd.getOptionValue("ub")) : Integer.MAX_VALUE;
            if (cp == null) {
                cp = "ff";
            }
            ref = cmd.getOptionValue("ref");
            if (ref == null) {
                ref = "greedy";
            }
            pm = cmd.getOptionValue("pm");
            if (pm == null) {
                pm = "replanning";
            }
            ip = (cmd.getOptionValue("ip") != null) ? cmd.getOptionValue("ip") : null;
            op = (cmd.getOptionValue("op") != null) ? cmd.getOptionValue("op") : null;

        } catch (ParseException ex) {
            System.err.println("Parsing failed.  Reason: " + ex.getMessage());
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp("cpces", options);
            System.exit(-1);
        }
    }
    


    private static void printStats(SimplePlan p) {
        if (p != null){
            System.out.println(p);
            System.out.println("|pi|:"+p.size());
        }else{
            System.out.println("Problem Unsolvable");
        }
        
        System.out.println("|S|:"+lastSampleCardinality);
        System.out.println("|I|:"+iteration);
        System.out.println("Sampling Time:"+samplingTime/1000000000.0+"s");
        System.out.println("Generation Time:"+cpTime/1000000000.0+"s");
        System.out.println("Conformant Planning Time:"+confPTime/1000000000.0+"s");
        
    }


}
