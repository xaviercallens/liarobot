package org.amcp.core;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the EventPriority enum.
 */
public class EventPriorityTest {
    
    @Test
    public void testEventPriorityValues() {
        EventPriority[] priorities = EventPriority.values();
        assertEquals(4, priorities.length);
        
        assertEquals(EventPriority.LOW, priorities[0]);
        assertEquals(EventPriority.NORMAL, priorities[1]);
        assertEquals(EventPriority.HIGH, priorities[2]);
        assertEquals(EventPriority.CRITICAL, priorities[3]);
    }
    
    @Test
    public void testEventPriorityValueOf() {
        assertEquals(EventPriority.LOW, EventPriority.valueOf("LOW"));
        assertEquals(EventPriority.NORMAL, EventPriority.valueOf("NORMAL"));
        assertEquals(EventPriority.HIGH, EventPriority.valueOf("HIGH"));
        assertEquals(EventPriority.CRITICAL, EventPriority.valueOf("CRITICAL"));
    }
    
    @Test
    public void testEventPriorityComparison() {
        assertTrue(EventPriority.LOW.ordinal() < EventPriority.NORMAL.ordinal());
        assertTrue(EventPriority.NORMAL.ordinal() < EventPriority.HIGH.ordinal());
        assertTrue(EventPriority.HIGH.ordinal() < EventPriority.CRITICAL.ordinal());
    }
}
