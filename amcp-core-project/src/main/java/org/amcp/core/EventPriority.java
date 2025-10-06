package org.amcp.core;

/**
 * Enumeration of event priorities in the AMCP mesh.
 * 
 * Priorities determine the order in which events are processed
 * when multiple events are queued for an agent.
 * 
 * @author AMCP Development Team
 * @version 1.5.0
 * @since 1.0.0
 */
public enum EventPriority {
    
    /**
     * Low priority events - processed when no higher priority events are available.
     */
    LOW,
    
    /**
     * Normal priority events - default priority for most events.
     */
    NORMAL,
    
    /**
     * High priority events - processed before normal and low priority events.
     */
    HIGH,
    
    /**
     * Critical priority events - processed immediately with highest precedence.
     */
    CRITICAL
}
