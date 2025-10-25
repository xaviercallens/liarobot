package org.amcp.cli;

import org.amcp.demo.AMCPDemo;

/**
 * Command-line interface for AMCP Core.
 * 
 * Provides a simple entry point for running AMCP demos and utilities.
 */
public class AMCPCli {
    
    public static void main(String[] args) {
        if (args.length == 0) {
            showHelp();
            return;
        }
        
        String command = args[0].toLowerCase();
        
        switch (command) {
            case "demo":
                System.out.println("🚀 Starting AMCP Interactive Demo...");
                AMCPDemo.main(new String[0]);
                break;
                
            case "version":
                showVersion();
                break;
                
            case "help":
            case "--help":
            case "-h":
                showHelp();
                break;
                
            default:
                System.err.println("❌ Unknown command: " + command);
                showHelp();
                System.exit(1);
        }
    }
    
    private static void showVersion() {
        System.out.println("AMCP Core v1.5.0");
        System.out.println("Agent Mesh Communication Protocol");
        System.out.println("Copyright (c) 2025 AMCP Development Team");
    }
    
    private static void showHelp() {
        System.out.println("AMCP Core CLI - Agent Mesh Communication Protocol");
        System.out.println();
        System.out.println("Usage: java -jar amcp-core-1.5.0.jar <command>");
        System.out.println();
        System.out.println("Commands:");
        System.out.println("  demo     - Run interactive AMCP demo");
        System.out.println("  version  - Show version information");
        System.out.println("  help     - Show this help message");
        System.out.println();
        System.out.println("Examples:");
        System.out.println("  java -jar amcp-core-1.5.0.jar demo");
        System.out.println("  java -jar amcp-core-1.5.0.jar version");
    }
}
