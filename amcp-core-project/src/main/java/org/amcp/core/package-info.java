/**
 * AMCP Core Framework - Agent Mesh Communication Protocol
 * 
 * <p>This package provides the core classes and interfaces for building
 * distributed agent systems using the Agent Mesh Communication Protocol (AMCP).
 * 
 * <h2>Key Components</h2>
 * <ul>
 *   <li>{@link org.amcp.core.Agent} - Base class for all AMCP agents</li>
 *   <li>{@link org.amcp.core.Event} - Event representation for agent communication</li>
 *   <li>{@link org.amcp.core.AgentContext} - Interface for mesh interaction</li>
 * </ul>
 * 
 * <h2>Basic Usage</h2>
 * <pre>{@code
 * public class MyAgent extends Agent {
 *     public MyAgent(String id) {
 *         super(id, "MyAgent");
 *     }
 *     
 *     @Override
 *     protected void onActivation() {
 *         subscribe("my.topic.*");
 *         
 *         Event event = Event.builder()
 *             .topic("my.topic.hello")
 *             .payload("Hello AMCP!")
 *             .build();
 *         publish(event);
 *     }
 * }
 * }</pre>
 * 
 * @author AMCP Development Team
 * @version 1.5.0
 * @since 1.0.0
 */
package org.amcp.core;
