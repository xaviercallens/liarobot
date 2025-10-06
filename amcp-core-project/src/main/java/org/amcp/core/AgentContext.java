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
     * Activates an agent in the mesh.
     * 
     * @param agent the agent to activate
     */
    void activateAgent(Agent agent);
    
    /**
     * Deactivates an agent from the mesh.
     * 
     * @param agent the agent to deactivate
     */
    void deactivateAgent(Agent agent);
    
    /**
     * Shuts down the agent context.
     */
    void shutdown();
}
