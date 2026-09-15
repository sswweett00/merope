package pool

import (
	"bytes"
	"sync"
)

var (
	// BufferPool provides reusable bytes.Buffer to reduce allocation overhead
	BufferPool = sync.Pool{
		New: func() interface{} {
			return new(bytes.Buffer)
		},
	}
)

// GetBuffer returns a clean buffer from the pool
func GetBuffer() *bytes.Buffer {
	buf := BufferPool.Get().(*bytes.Buffer)
	buf.Reset()
	return buf
}

// PutBuffer returns a buffer to the pool
func PutBuffer(buf *bytes.Buffer) {
	// Don't pool very large buffers to avoid memory leaks
	if buf.Cap() > 64*1024 { // 64KB limit
		return
	}
	BufferPool.Put(buf)
}

// BytePool provides reusable byte slices of a fixed size
type BytePool struct {
	pool sync.Pool
	size int
}

func NewBytePool(size int) *BytePool {
	return &BytePool{
		size: size,
		pool: sync.Pool{
			New: func() interface{} {
				return make([]byte, size)
			},
		},
	}
}

func (p *BytePool) Get() []byte {
	return p.pool.Get().([]byte)
}

func (p *BytePool) Put(b []byte) {
	if len(b) != p.size {
		return
	}
	p.pool.Put(b)
}
