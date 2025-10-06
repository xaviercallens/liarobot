package org.amcp.core;

/**
 * Interface for agent context within the AMCP mesh.
 * 
 * Provides methods for agents to interact with the mesh,
 * including publishing events and managing subscriptions.
 * 
 * @author AMCP Development Team
 * @version 1.5.0
 * @since 1.0.0
 */
public interface AgentContext {
    
    /**
     * Publishes an event to the mesh.
     * 
     * @param event the event to publish
     */
    void publish(Event event);
    
    /**
     * Subscribes an agent to a topic.
     * 
     * @param agent the agent to subscribe
     * @param topic the topic to subscribe to
     */
    void subscribe(Agent agent, String topic);
    
    /**
     * Unsubscribes an agent from a topic.
     * 
     * @param agent the agent to unsubscribe
     * @param topic the topic to unsubscribe from
     */
    void unsubscribe(Agent agent, String topic);
    
    /**
     * Publishes an event to the mesh (alias for publish).
     * 
     * @param event the event to publish
     */
    default void publishEvent(Event event) {
        publish(event);
    }
    
    /**
     * Subscribes an agent to a topic pattern.
     * 
     * @param agentId the agent ID to subscribe
     * @param topicPattern the topic pattern to subscribe to
     */
    void subscribeToTopic(String agentId, String topicPattern);
    
    /**
     * Unsubscribes an agent from a topic pattern.
     * 
     * @param agentId the agent ID to unsubscribe
     * @param topicPattern the topic pattern to unsubscribe from
     */
    void unsubscribeFromTopic(String agentId, String topicPattern);
    
    /**
     * Registers an agent in the mesh.
     * 
     * @param agentId the agent ID
     * @param agentType the agent type
     */
    void registerAgent(String agentId, String agentType);
    
    /**
     * Unregisters an agent from the mesh.
     * 
     * @param agentId the agent ID
     */
    void unregisterAgent(String agentId);
    
    /**
     * Activates an agent in the mesh.
     * 
     * @param agent the agent to activate
     */
    default void activateAgent(Agent agent) {
        registerAgent(agent.getId(), agent.getType());
    }
    
    /**
     * Deactivates an agent from the mesh.
     * 
     * @param agent the agent to deactivate
     */
    default void deactivateAgent(Agent agent) {
        unregisterAgent(agent.getId());
    }
    
    /**
     * Shuts down the agent context.
     */
    default void shutdown() {
        // Default implementation does nothing
    }
}
