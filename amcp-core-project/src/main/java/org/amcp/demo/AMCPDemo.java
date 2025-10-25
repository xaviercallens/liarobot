package org.amcp.demo;

import org.amcp.core.Agent;
import org.amcp.core.AgentContext;
import org.amcp.core.Event;
import org.amcp.core.EventPriority;

import java.time.Instant;
import java.util.Scanner;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.Map;
import java.util.List;

/**
 * Interactive CLI demo for AMCP Core framework.
 * Demonstrates agent creation, event publishing, and mesh communication.
 */
public class AMCPDemo {
    
    private static final Map<String, DemoAgent> agents = new ConcurrentHashMap<>();
    private static final List<Event> eventLog = new CopyOnWriteArrayList<>();
    private static final Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {
        System.out.println("🚀 AMCP Core v1.5.0 - Interactive Demo");
        System.out.println("=====================================");
        System.out.println();
        
        // Create demo context
        DemoAgentContext context = new DemoAgentContext();
        
        // Create some demo agents
        createDemoAgents(context);
        
        // Start interactive loop
        runInteractiveDemo();
    }
    
    private static void createDemoAgents(DemoAgentContext context) {
        System.out.println("📦 Creating demo agents...");
        
        // Create different types of agents
        DemoAgent chatAgent = new DemoAgent("chat-001", "ChatAgent", context);
        DemoAgent dataAgent = new DemoAgent("data-001", "DataAgent", context);
        DemoAgent monitorAgent = new DemoAgent("monitor-001", "MonitorAgent", context);
        
        agents.put(chatAgent.getId(), chatAgent);
        agents.put(dataAgent.getId(), dataAgent);
        agents.put(monitorAgent.getId(), monitorAgent);
        
        // Activate all agents
        try {
            chatAgent.activate();
            dataAgent.activate();
            monitorAgent.activate();
            
            System.out.println("✅ Created and activated " + agents.size() + " demo agents");
            System.out.println();
        } catch (Exception e) {
            System.err.println("❌ Error activating agents: " + e.getMessage());
        }
    }
    
    private static void runInteractiveDemo() {
        System.out.println("🎮 Interactive Demo Commands:");
        System.out.println("  1. list    - List all agents");
        System.out.println("  2. send    - Send event between agents");
        System.out.println("  3. status  - Show agent status");
        System.out.println("  4. events  - Show event log");
        System.out.println("  5. create  - Create new agent");
        System.out.println("  6. help    - Show this help");
        System.out.println("  7. quit    - Exit demo");
        System.out.println();
        
        while (true) {
            System.out.print("amcp> ");
            String command = scanner.nextLine().trim().toLowerCase();
            
            switch (command) {
                case "1":
                case "list":
                    listAgents();
                    break;
                case "2":
                case "send":
                    sendEvent();
                    break;
                case "3":
                case "status":
                    showStatus();
                    break;
                case "4":
                case "events":
                    showEvents();
                    break;
                case "5":
                case "create":
                    createAgent();
                    break;
                case "6":
                case "help":
                    runInteractiveDemo();
                    return;
                case "7":
                case "quit":
                case "exit":
                    shutdown();
                    return;
                default:
                    System.out.println("❓ Unknown command. Type 'help' for available commands.");
            }
            System.out.println();
        }
    }
    
    private static void listAgents() {
        System.out.println("📋 Active Agents:");
        if (agents.isEmpty()) {
            System.out.println("  No agents currently active");
            return;
        }
        
        for (DemoAgent agent : agents.values()) {
            System.out.printf("  🤖 %s (%s) - %s%n", 
                agent.getId(), 
                agent.getType(), 
                agent.getState());
        }
    }
    
    private static void sendEvent() {
        if (agents.size() < 2) {
            System.out.println("❌ Need at least 2 agents to send events");
            return;
        }
        
        System.out.println("📡 Send Event:");
        System.out.print("From agent ID: ");
        String fromId = scanner.nextLine().trim();
        
        System.out.print("To agent ID (or 'broadcast'): ");
        String toId = scanner.nextLine().trim();
        
        System.out.print("Event topic: ");
        String topic = scanner.nextLine().trim();
        
        System.out.print("Message: ");
        String message = scanner.nextLine().trim();
        
        DemoAgent fromAgent = agents.get(fromId);
        if (fromAgent == null) {
            System.out.println("❌ Agent not found: " + fromId);
            return;
        }
        
        try {
            Event event = Event.builder()
                .topic(topic)
                .payload(message)
                .source(fromId)
                .target("broadcast".equals(toId) ? null : toId)
                .priority(EventPriority.NORMAL)
                .build();
            
            fromAgent.publish(event);
            System.out.println("✅ Event sent successfully!");
            
        } catch (Exception e) {
            System.out.println("❌ Error sending event: " + e.getMessage());
        }
    }
    
    private static void showStatus() {
        System.out.println("📊 System Status:");
        System.out.println("  Active Agents: " + agents.size());
        System.out.println("  Total Events: " + eventLog.size());
        System.out.println("  Uptime: " + getUptime());
        
        System.out.println("\n🤖 Agent Details:");
        for (DemoAgent agent : agents.values()) {
            System.out.printf("  %s: %s (Events: %d)%n", 
                agent.getId(), 
                agent.getState(),
                agent.getEventCount());
        }
    }
    
    private static void showEvents() {
        System.out.println("📝 Event Log (last 10 events):");
        if (eventLog.isEmpty()) {
            System.out.println("  No events recorded");
            return;
        }
        
        int start = Math.max(0, eventLog.size() - 10);
        for (int i = start; i < eventLog.size(); i++) {
            Event event = eventLog.get(i);
            System.out.printf("  [%d] %s -> %s: %s (%s)%n",
                i + 1,
                event.getSource() != null ? event.getSource() : "system",
                event.getTarget() != null ? event.getTarget() : "broadcast",
                event.getTopic(),
                event.getTimestamp());
        }
    }
    
    private static void createAgent() {
        System.out.println("🏗️ Create New Agent:");
        System.out.print("Agent ID: ");
        String id = scanner.nextLine().trim();
        
        if (agents.containsKey(id)) {
            System.out.println("❌ Agent with ID '" + id + "' already exists");
            return;
        }
        
        System.out.print("Agent Type: ");
        String type = scanner.nextLine().trim();
        
        try {
            DemoAgentContext context = new DemoAgentContext();
            DemoAgent agent = new DemoAgent(id, type, context);
            agent.activate();
            
            agents.put(id, agent);
            System.out.println("✅ Agent created and activated: " + id);
            
        } catch (Exception e) {
            System.out.println("❌ Error creating agent: " + e.getMessage());
        }
    }
    
    private static void shutdown() {
        System.out.println("🛑 Shutting down demo...");
        
        for (DemoAgent agent : agents.values()) {
            try {
                agent.deactivate();
            } catch (Exception e) {
                System.err.println("Error deactivating agent " + agent.getId() + ": " + e.getMessage());
            }
        }
        
        agents.clear();
        System.out.println("✅ Demo shutdown complete. Goodbye!");
    }
    
    private static String getUptime() {
        // Simple uptime calculation (demo purposes)
        return "Demo session active";
    }
    
    /**
     * Demo implementation of Agent with enhanced functionality
     */
    static class DemoAgent extends Agent {
        private final DemoAgentContext context;
        private int eventCount = 0;
        
        public DemoAgent(String id, String type, DemoAgentContext context) {
            super(id, type);
            this.context = context;
        }
        
        @Override
        protected void onActivation() {
            System.out.println("🟢 Agent activated: " + getId() + " (" + getType() + ")");
            
            // Subscribe to relevant topics
            subscribe(getType().toLowerCase() + ".*");
            subscribe("broadcast.*");
            subscribe("system.*");
        }
        
        @Override
        protected void onDeactivation() {
            System.out.println("🔴 Agent deactivated: " + getId());
        }
        
        @Override
        protected void onEventReceived(Event event) {
            eventCount++;
            eventLog.add(event);
            
            System.out.printf("📨 %s received: %s from %s%n", 
                getId(), 
                event.getTopic(),
                event.getSource() != null ? event.getSource() : "system");
            
            // Auto-respond to certain events
            if (event.getTopic().startsWith("ping")) {
                try {
                    Event response = Event.builder()
                        .topic("pong." + getType().toLowerCase())
                        .payload("Pong from " + getId())
                        .source(getId())
                        .target(event.getSource())
                        .correlationId(event.getId())
                        .build();
                    
                    publish(response);
                } catch (Exception e) {
                    System.err.println("Error sending pong: " + e.getMessage());
                }
            }
        }
        
        public int getEventCount() {
            return eventCount;
        }
    }
    
    /**
     * Demo implementation of AgentContext
     */
    static class DemoAgentContext implements AgentContext {
        
        @Override
        public void publish(Event event) {
            publishEvent(event);
        }
        
        @Override
        public void publishEvent(Event event) {
            eventLog.add(event);
            
            // Deliver to target agent or broadcast
            if (event.getTarget() != null) {
                DemoAgent target = agents.get(event.getTarget());
                if (target != null) {
                    target.handleEvent(event);
                }
            } else {
                // Broadcast to all agents except sender
                for (DemoAgent agent : agents.values()) {
                    if (!agent.getId().equals(event.getSource())) {
                        agent.handleEvent(event);
                    }
                }
            }
        }
        
        @Override
        public void subscribe(Agent agent, String topic) {
            subscribeToTopic(agent.getId(), topic);
        }
        
        @Override
        public void unsubscribe(Agent agent, String topic) {
            unsubscribeFromTopic(agent.getId(), topic);
        }
        
        @Override
        public void subscribeToTopic(String agentId, String topicPattern) {
            System.out.printf("📡 %s subscribed to: %s%n", agentId, topicPattern);
        }
        
        @Override
        public void unsubscribeFromTopic(String agentId, String topicPattern) {
            System.out.printf("📡 %s unsubscribed from: %s%n", agentId, topicPattern);
        }
        
        @Override
        public void registerAgent(String agentId, String agentType) {
            System.out.printf("📋 Agent registered: %s (%s)%n", agentId, agentType);
        }
        
        @Override
        public void unregisterAgent(String agentId) {
            System.out.printf("📋 Agent unregistered: %s%n", agentId);
        }
    }
}
