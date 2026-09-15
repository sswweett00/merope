package util

import (
	"container/list"
	"sync"
)

type entry[K comparable, V any] struct {
	key   K
	value V
}

/// LRUCache is a simple thread-safe L1 in-memory cache.
type LRUCache[K comparable, V any] struct {
	capacity int
	cache    map[K]*list.Element
	list     *list.List
	mu       sync.RWMutex
}

func NewLRUCache[K comparable, V any](capacity int) *LRUCache[K, V] {
	return &LRUCache[K, V]{
		capacity: capacity,
		cache:    make(map[K]*list.Element),
		list:     list.New(),
	}
}

func (c *LRUCache[K, V]) Get(key K) (V, bool) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if elem, ok := c.cache[key]; ok {
		c.list.MoveToFront(elem)
		return elem.Value.(*entry[K, V]).value, true
	}

	var zero V
	return zero, false
}

func (c *LRUCache[K, V]) Put(key K, value V) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if elem, ok := c.cache[key]; ok {
		c.list.MoveToFront(elem)
		elem.Value.(*entry[K, V]).value = value
		return
	}

	if c.list.Len() >= c.capacity {
		c.removeOldest()
	}

	ent := &entry[K, V]{key: key, value: value}
	elem := c.list.PushFront(ent)
	c.cache[key] = elem
}

func (c *LRUCache[K, V]) removeOldest() {
	elem := c.list.Back()
	if elem != nil {
		c.list.Remove(elem)
		ent := elem.Value.(*entry[K, V])
		delete(c.cache, ent.key)
	}
}

func (c *LRUCache[K, V]) Clear() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.cache = make(map[K]*list.Element)
	c.list.Init()
}
