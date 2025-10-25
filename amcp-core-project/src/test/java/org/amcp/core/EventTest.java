package org.amcp.core;

import org.junit.jupiter.api.Test;
import java.time.Instant;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the Event class.
 */
public class EventTest {
    
    @Test
    public void testEventBuilder() {
        String topic = "test.topic";
        String payload = "test payload";
        String sender = "test-agent";
        
        Event event = Event.builder()
            .topic(topic)
            .payload(payload)
            .sender(sender)
            .build();
        
        assertNotNull(event.getId());
        assertEquals(topic, event.getTopic());
        assertEquals(payload, event.getPayload());
        assertEquals(sender, event.getSender());
        assertNotNull(event.getTimestamp());
        assertEquals(EventPriority.NORMAL, event.getPriority());
    }
    
    @Test
    public void testEventWithMetadata() {
        Event event = Event.builder()
            .topic("test.topic")
            .payload("test")
            .metadata("key1", "value1")
            .metadata("key2", "value2")
            .build();
        
        Map<String, String> metadata = event.getMetadata();
        assertEquals("value1", metadata.get("key1"));
        assertEquals("value2", metadata.get("key2"));
        assertEquals("value1", event.getMetadata("key1"));
    }
    
    @Test
    public void testEventEquality() {
        String eventId = "test-id";
        
        Event event1 = Event.builder()
            .id(eventId)
            .topic("test.topic")
            .payload("test")
            .build();
            
        Event event2 = Event.builder()
            .id(eventId)
            .topic("different.topic")
            .payload("different")
            .build();
        
        assertEquals(event1, event2); // Same ID
        assertEquals(event1.hashCode(), event2.hashCode());
    }
    
    @Test
    public void testPayloadTypeCasting() {
        Map<String, Object> payload = Map.of("key", "value", "number", 42);
        
        Event event = Event.builder()
            .topic("test.topic")
            .payload(payload)
            .build();
        
        @SuppressWarnings("unchecked")
        Map<String, Object> retrievedPayload = event.getPayload(Map.class);
        assertEquals(payload, retrievedPayload);
    }
    
    @Test
    public void testToBuilder() {
        Event original = Event.builder()
            .topic("original.topic")
            .payload("original payload")
            .sender("original-sender")
            .priority(EventPriority.HIGH)
            .build();
        
        Event modified = original.toBuilder()
            .topic("modified.topic")
            .build();
        
        assertEquals("modified.topic", modified.getTopic());
        assertEquals("original payload", modified.getPayload());
        assertEquals("original-sender", modified.getSender());
        assertEquals(EventPriority.HIGH, modified.getPriority());
        assertEquals(original.getId(), modified.getId());
    }
}
