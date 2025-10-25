package org.amcp.core;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Map;

/**
 * Unit tests for the Agent class.
 */
public class AgentTest {
    
    @Test
    public void testAgentCreation() {
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        assertEquals("test-001", agent.getId());
        assertEquals("TestAgent", agent.getType());
        assertNotNull(agent.getState());
    }
    
    @Test
    public void testAgentActivation() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        
        agent.activate();
        assertEquals(AgentState.ACTIVE, agent.getState());
        assertNotNull(agent.getActivationTime());
    }
    
    @Test
    public void testAgentDeactivation() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        
        agent.activate();
        agent.deactivate();
        assertEquals(AgentState.DEACTIVATED, agent.getState());
    }
    
    @Test
    public void testPublishEvent() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        agent.activate();
        
        Event event = Event.builder()
            .topic("test.topic")
            .payload("test payload")
            .build();
        
        agent.publish(event);
        
        assertEquals(1, context.publishedEvents.size());
        assertEquals("test.topic", context.publishedEvents.get(0).getTopic());
    }
    
    @Test
    public void testSubscribeToTopic() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        agent.activate();
        
        assertTrue(agent.getSubscriptions().contains("test.*"));
    }
    
    @Test
    public void testMetadata() {
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setMetadata("key1", "value1");
        agent.setMetadata("key2", 123);
        
        Map<String, Object> metadata = agent.getMetadata();
        assertEquals("value1", metadata.get("key1"));
        assertEquals(123, metadata.get("key2"));
    }
    
    @Test
    public void testCapabilities() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        agent.announceCapability("test.capability", "1.0");
        
        Map<String, String> capabilities = agent.getCapabilities();
        assertEquals("1.0", capabilities.get("test.capability"));
    }
    
    @Test
    public void testEventHandling() {
        TestAgentContext context = new TestAgentContext();
        TestAgent agent = new TestAgent("test-001", "TestAgent");
        agent.setContext(context);
        agent.activate();
        
        Event event = Event.builder()
            .topic("test.event")
            .payload("test data")
            .build();
        
        agent.handleEvent(event);
        
        assertTrue(agent.receivedEvents.contains(event));
    }
    
    @Test
    public void testAgentEquality() {
        TestAgent agent1 = new TestAgent("test-001", "TestAgent");
        TestAgent agent2 = new TestAgent("test-001", "TestAgent");
        TestAgent agent3 = new TestAgent("test-002", "TestAgent");
        
        assertEquals(agent1, agent2);
        assertNotEquals(agent1, agent3);
    }
    
    @Test
    public void testAgentHashCode() {
        TestAgent agent1 = new TestAgent("test-001", "TestAgent");
        TestAgent agent2 = new TestAgent("test-001", "TestAgent");
        
        assertEquals(agent1.hashCode(), agent2.hashCode());
    }
    
    /**
     * Test agent implementation
     */
    static class TestAgent extends Agent {
        java.util.List<Event> receivedEvents = new java.util.ArrayList<>();
        
        public TestAgent(String id, String type) {
            super(id, type);
        }
        
        @Override
        protected void onActivation() {
            subscribe("test.*");
        }
        
        @Override
        protected void onEventReceived(Event event) {
            receivedEvents.add(event);
        }
    }
    
    /**
     * Test agent context implementation
     */
    static class TestAgentContext implements AgentContext {
        java.util.List<Event> publishedEvents = new java.util.ArrayList<>();
        
        @Override
        public void publish(Event event) {
            publishedEvents.add(event);
        }
        
        @Override
        public void subscribe(Agent agent, String topic) {
            // Test implementation
        }
        
        @Override
        public void unsubscribe(Agent agent, String topic) {
            // Test implementation
        }
        
        @Override
        public void subscribeToTopic(String agentId, String topicPattern) {
            // Test implementation
        }
        
        @Override
        public void unsubscribeFromTopic(String agentId, String topicPattern) {
            // Test implementation
        }
        
        @Override
        public void registerAgent(String agentId, String agentType) {
            // Test implementation
        }
        
        @Override
        public void unregisterAgent(String agentId) {
            // Test implementation
        }
    }
}
