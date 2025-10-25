package org.amcp.core;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Base class for all AMCP agents.
 * 
 * Provides core functionality for agent lifecycle management,
 * event handling, and communication within the agent mesh.
 * 
 * @author AMCP Development Team
 * @version 1.5.0
 * @since 1.0.0
 */
public abstract class Agent {
    
    private static final Logger logger = LoggerFactory.getLogger(Agent.class);
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    private final String agentId;
    private final String agentType;
    private final Map<String, Object> metadata;
    private final List<String> subscriptions;
    private final Map<String, String> capabilities;
    
    private AgentState state;
    private AgentContext context;
    private Instant activationTime;
    private Instant lastActivityTime;
    
    /**
     * Creates a new agent with the specified ID and type.
     * 
     * @param agentId unique identifier for this agent
     * @param agentType the type/class of this agent
     */
    protected Agent(String agentId, String agentType) {
        this.agentId = Objects.requireNonNull(agentId, "Agent ID cannot be null");
        this.agentType = Objects.requireNonNull(agentType, "Agent type cannot be null");
        this.metadata = new ConcurrentHashMap<>();
        this.subscriptions = new CopyOnWriteArrayList<>();
        this.capabilities = new ConcurrentHashMap<>();
        this.state = AgentState.CREATED;
        
        logger.info("Agent created: {} [{}]", agentId, agentType);
    }
    
    /**
     * Gets the unique identifier for this agent.
     * 
     * @return the agent ID
     */
    public final String getAgentId() {
        return agentId;
    }
    
    /**
     * Gets the type of this agent.
     * 
     * @return the agent type
     */
    public final String getAgentType() {
        return agentType;
    }
    
    /**
     * Gets the current state of this agent.
     * 
     * @return the agent state
     */
    public final AgentState getState() {
        return state;
    }
    
    /**
     * Gets the agent context for mesh communication.
     * 
     * @return the agent context
     */
    protected final AgentContext getContext() {
        return context;
    }
    
    /**
     * Sets the agent context. Called by the AMCP framework.
     * 
     * @param context the agent context
     */
    public final void setContext(AgentContext context) {
        this.context = context;
    }
    
    /**
     * Activates this agent within the mesh.
     * 
     * This method is called by the AMCP framework when the agent
     * is being activated. Subclasses should override {@link #onActivation()}
     * to perform custom initialization.
     */
    public final void activate() {
        if (state != AgentState.CREATED) {
            throw new IllegalStateException("Agent can only be activated from CREATED state");
        }
        
        state = AgentState.ACTIVATING;
        activationTime = Instant.now();
        lastActivityTime = activationTime;
        
        try {
            onActivation();
            state = AgentState.ACTIVE;
            logger.info("Agent activated: {} [{}]", agentId, agentType);
        } catch (Exception e) {
            state = AgentState.ERROR;
            logger.error("Failed to activate agent: {} [{}]", agentId, agentType, e);
            throw new AgentActivationException("Failed to activate agent: " + agentId, e);
        }
    }
    
    /**
     * Deactivates this agent from the mesh.
     * 
     * This method is called by the AMCP framework when the agent
     * is being deactivated. Subclasses should override {@link #onDeactivation()}
     * to perform custom cleanup.
     */
    public final void deactivate() {
        if (state != AgentState.ACTIVE) {
            logger.warn("Attempting to deactivate agent in state: {}", state);
        }
        
        state = AgentState.DEACTIVATING;
        
        try {
            onDeactivation();
            state = AgentState.DEACTIVATED;
            logger.info("Agent deactivated: {} [{}]", agentId, agentType);
        } catch (Exception e) {
            state = AgentState.ERROR;
            logger.error("Failed to deactivate agent: {} [{}]", agentId, agentType, e);
            throw new AgentDeactivationException("Failed to deactivate agent: " + agentId, e);
        }
    }
    
    /**
     * Called when the agent is being activated.
     * 
     * Subclasses should override this method to perform custom
     * initialization such as subscribing to topics and announcing
     * capabilities.
     */
    protected void onActivation() {
        // Default implementation does nothing
    }
    
    /**
     * Called when the agent is being deactivated.
     * 
     * Subclasses should override this method to perform custom
     * cleanup such as unsubscribing from topics and releasing
     * resources.
     */
    protected void onDeactivation() {
        // Default implementation does nothing
    }
    
    /**
     * Subscribes to events on the specified topic.
     * 
     * @param topic the topic to subscribe to (supports wildcards)
     */
    protected final void subscribe(String topic) {
        Objects.requireNonNull(topic, "Topic cannot be null");
        
        if (!subscriptions.contains(topic)) {
            subscriptions.add(topic);
            if (context != null) {
                context.subscribe(this, topic);
            }
            logger.debug("Agent {} subscribed to topic: {}", agentId, topic);
        }
    }
    
    /**
     * Unsubscribes from events on the specified topic.
     * 
     * @param topic the topic to unsubscribe from
     */
    protected final void unsubscribe(String topic) {
        Objects.requireNonNull(topic, "Topic cannot be null");
        
        if (subscriptions.remove(topic)) {
            if (context != null) {
                context.unsubscribe(this, topic);
            }
            logger.debug("Agent {} unsubscribed from topic: {}", agentId, topic);
        }
    }
    
    /**
     * Publishes an event to the mesh.
     * 
     * @param event the event to publish
     */
    public final void publish(Event event) {
        Objects.requireNonNull(event, "Event cannot be null");
        
        if (context == null) {
            throw new IllegalStateException("Agent context not set");
        }
        
        // Set sender if not already set
        if (event.getSender() == null) {
            event = event.toBuilder().sender(agentId).build();
        }
        
        context.publish(event);
        lastActivityTime = Instant.now();
        
        logger.debug("Agent {} published event to topic: {}", agentId, event.getTopic());
    }
    
    /**
     * Announces a capability of this agent.
     * 
     * @param capability the capability name
     * @param version the capability version
     */
    protected final void announceCapability(String capability, String version) {
        Objects.requireNonNull(capability, "Capability cannot be null");
        Objects.requireNonNull(version, "Version cannot be null");
        
        capabilities.put(capability, version);
        
        if (context != null) {
            Event capabilityEvent = Event.builder()
                .topic("system.capability.announce")
                .payload(Map.of(
                    "agentId", agentId,
                    "capability", capability,
                    "version", version
                ))
                .sender(agentId)
                .build();
                
            context.publish(capabilityEvent);
        }
        
        logger.debug("Agent {} announced capability: {} v{}", agentId, capability, version);
    }
    
    /**
     * Logs a message with the agent ID as context.
     * 
     * @param message the message to log
     */
    protected final void log(String message) {
        logger.info("[{}] {}", agentId, message);
    }
    
    /**
     * Logs a message with arguments and the agent ID as context.
     * 
     * @param message the message template
     * @param args the message arguments
     */
    protected final void log(String message, Object... args) {
        logger.info("[{}] " + message, agentId, args);
    }
    
    /**
     * Gets the agent's metadata.
     * 
     * @return a copy of the metadata map
     */
    public final Map<String, Object> getMetadata() {
        return new HashMap<>(metadata);
    }
    
    /**
     * Sets a metadata value.
     * 
     * @param key the metadata key
     * @param value the metadata value
     */
    protected final void setMetadata(String key, Object value) {
        metadata.put(key, value);
    }
    
    /**
     * Gets the agent's subscriptions.
     * 
     * @return a copy of the subscriptions list
     */
    public final List<String> getSubscriptions() {
        return new ArrayList<>(subscriptions);
    }
    
    /**
     * Gets the agent's capabilities.
     * 
     * @return a copy of the capabilities map
     */
    public final Map<String, String> getCapabilities() {
        return new HashMap<>(capabilities);
    }
    
    /**
     * Gets the time when this agent was activated.
     * 
     * @return the activation time, or null if not activated
     */
    public final Instant getActivationTime() {
        return activationTime;
    }
    
    /**
     * Gets the time of the last activity (event published).
     * 
     * @return the last activity time
     */
    public final Instant getLastActivityTime() {
        return lastActivityTime;
    }
    
    /**
     * Handles an incoming event. Called by the AMCP framework.
     * 
     * @param event the event to handle
     */
    public final void handleEvent(Event event) {
        if (state != AgentState.ACTIVE) {
            logger.warn("Agent {} received event while not active: {}", agentId, state);
            return;
        }
        
        lastActivityTime = Instant.now();
        
        try {
            onEventReceived(event);
        } catch (Exception e) {
            logger.error("Error handling event in agent {}: {}", agentId, e.getMessage(), e);
        }
    }
    
    /**
     * Called when an event is received by this agent.
     * 
     * Subclasses should override this method to handle incoming events.
     * 
     * @param event the received event
     */
    protected void onEventReceived(Event event) {
        // Default implementation does nothing
    }
    
    /**
     * Convenience method to get agent ID (alias for getAgentId).
     * 
     * @return the agent ID
     */
    public final String getId() {
        return agentId;
    }
    
    /**
     * Convenience method to get agent type (alias for getAgentType).
     * 
     * @return the agent type
     */
    public final String getType() {
        return agentType;
    }
    
    @Override
    public String toString() {
        return String.format("Agent{id='%s', type='%s', state=%s}", 
            agentId, agentType, state);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Agent agent = (Agent) obj;
        return Objects.equals(agentId, agent.agentId);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(agentId);
    }
}

/**
 * Enumeration of agent states.
 */
enum AgentState {
    CREATED,
    ACTIVATING,
    ACTIVE,
    DEACTIVATING,
    DEACTIVATED,
    ERROR
}

/**
 * Exception thrown when agent activation fails.
 */
class AgentActivationException extends RuntimeException {
    public AgentActivationException(String message, Throwable cause) {
        super(message, cause);
    }
}

/**
 * Exception thrown when agent deactivation fails.
 */
class AgentDeactivationException extends RuntimeException {
    public AgentDeactivationException(String message, Throwable cause) {
        super(message, cause);
    }
}
