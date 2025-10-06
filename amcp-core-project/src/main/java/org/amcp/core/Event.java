package org.amcp.core;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Represents an event in the AMCP mesh.
 * 
 * Events are the primary means of communication between agents.
 * They contain a topic, payload, and metadata for routing and processing.
 * 
 * @author AMCP Development Team
 * @version 1.5.0
 * @since 1.0.0
 */
public final class Event {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    private final String id;
    private final String topic;
    private final Object payload;
    private final String sender;
    private final String correlationId;
    private final Instant timestamp;
    private final Map<String, String> metadata;
    private final EventPriority priority;
    
    @JsonCreator
    private Event(
            @JsonProperty("id") String id,
            @JsonProperty("topic") String topic,
            @JsonProperty("payload") Object payload,
            @JsonProperty("sender") String sender,
            @JsonProperty("correlationId") String correlationId,
            @JsonProperty("timestamp") Instant timestamp,
            @JsonProperty("metadata") Map<String, String> metadata,
            @JsonProperty("priority") EventPriority priority) {
        
        this.id = id != null ? id : UUID.randomUUID().toString();
        this.topic = Objects.requireNonNull(topic, "Topic cannot be null");
        this.payload = payload;
        this.sender = sender;
        this.correlationId = correlationId;
        this.timestamp = timestamp != null ? timestamp : Instant.now();
        this.metadata = metadata != null ? new HashMap<>(metadata) : new HashMap<>();
        this.priority = priority != null ? priority : EventPriority.NORMAL;
    }
    
    /**
     * Gets the unique identifier of this event.
     * 
     * @return the event ID
     */
    public String getId() {
        return id;
    }
    
    /**
     * Gets the topic of this event.
     * 
     * @return the topic
     */
    public String getTopic() {
        return topic;
    }
    
    /**
     * Gets the payload of this event.
     * 
     * @return the payload
     */
    public Object getPayload() {
        return payload;
    }
    
    /**
     * Gets the payload as the specified type.
     * 
     * @param <T> the payload type
     * @param type the payload class
     * @return the payload cast to the specified type
     * @throws ClassCastException if the payload cannot be cast to the specified type
     */
    @SuppressWarnings("unchecked")
    public <T> T getPayload(Class<T> type) {
        if (payload == null) {
            return null;
        }
        
        if (type.isInstance(payload)) {
            return (T) payload;
        }
        
        // Try to convert using Jackson
        try {
            return objectMapper.convertValue(payload, type);
        } catch (Exception e) {
            throw new ClassCastException("Cannot convert payload to " + type.getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * Gets the sender of this event.
     * 
     * @return the sender agent ID
     */
    public String getSender() {
        return sender;
    }
    
    /**
     * Gets the correlation ID of this event.
     * 
     * @return the correlation ID
     */
    public String getCorrelationId() {
        return correlationId;
    }
    
    /**
     * Gets the timestamp of this event.
     * 
     * @return the timestamp
     */
    public Instant getTimestamp() {
        return timestamp;
    }
    
    /**
     * Gets the metadata of this event.
     * 
     * @return a copy of the metadata map
     */
    public Map<String, String> getMetadata() {
        return new HashMap<>(metadata);
    }
    
    /**
     * Gets a metadata value.
     * 
     * @param key the metadata key
     * @return the metadata value, or null if not found
     */
    public String getMetadata(String key) {
        return metadata.get(key);
    }
    
    /**
     * Gets the priority of this event.
     * 
     * @return the priority
     */
    public EventPriority getPriority() {
        return priority;
    }
    
    /**
     * Creates a new builder for constructing events.
     * 
     * @return a new event builder
     */
    public static Builder builder() {
        return new Builder();
    }
    
    /**
     * Creates a new builder initialized with this event's values.
     * 
     * @return a new event builder
     */
    public Builder toBuilder() {
        return new Builder()
            .id(id)
            .topic(topic)
            .payload(payload)
            .sender(sender)
            .correlationId(correlationId)
            .timestamp(timestamp)
            .metadata(metadata)
            .priority(priority);
    }
    
    @Override
    public String toString() {
        return String.format("Event{id='%s', topic='%s', sender='%s', timestamp=%s}", 
            id, topic, sender, timestamp);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Event event = (Event) obj;
        return Objects.equals(id, event.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    /**
     * Builder for constructing Event instances.
     */
    public static final class Builder {
        private String id;
        private String topic;
        private Object payload;
        private String sender;
        private String correlationId;
        private Instant timestamp;
        private Map<String, String> metadata = new HashMap<>();
        private EventPriority priority;
        
        private Builder() {}
        
        public Builder id(String id) {
            this.id = id;
            return this;
        }
        
        public Builder topic(String topic) {
            this.topic = topic;
            return this;
        }
        
        public Builder payload(Object payload) {
            this.payload = payload;
            return this;
        }
        
        public Builder sender(String sender) {
            this.sender = sender;
            return this;
        }
        
        public Builder correlationId(String correlationId) {
            this.correlationId = correlationId;
            return this;
        }
        
        public Builder timestamp(Instant timestamp) {
            this.timestamp = timestamp;
            return this;
        }
        
        public Builder metadata(String key, String value) {
            this.metadata.put(key, value);
            return this;
        }
        
        public Builder metadata(Map<String, String> metadata) {
            this.metadata.putAll(metadata);
            return this;
        }
        
        public Builder priority(EventPriority priority) {
            this.priority = priority;
            return this;
        }
        
        public Builder from(Event event) {
            this.id = event.id;
            this.topic = event.topic;
            this.payload = event.payload;
            this.sender = event.sender;
            this.correlationId = event.correlationId;
            this.timestamp = event.timestamp;
            this.metadata.putAll(event.metadata);
            this.priority = event.priority;
            return this;
        }
        
        public Event build() {
            return new Event(id, topic, payload, sender, correlationId, 
                timestamp, metadata, priority);
        }
    }
}

/**
 * Enumeration of event priorities.
 */
enum EventPriority {
    LOW,
    NORMAL,
    HIGH,
    CRITICAL
}
