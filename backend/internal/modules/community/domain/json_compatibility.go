package domain

import (
	"encoding/json"
	"reflect"
	"strings"
	"unicode"
)

func marshalCommunityWire(value interface{}) ([]byte, error) {
	return json.Marshal(toCommunityWireValue(reflect.ValueOf(value)))
}

func toCommunityWireValue(v reflect.Value) interface{} {
	if !v.IsValid() {
		return nil
	}
	if v.Kind() == reflect.Interface || v.Kind() == reflect.Pointer {
		if v.IsNil() {
			return nil
		}
		return toCommunityWireValue(v.Elem())
	}
	if v.Type().PkgPath() == "time" && v.Type().Name() == "Time" {
		return v.Interface()
	}

	switch v.Kind() {
	case reflect.Struct:
		out := make(map[string]interface{})
		t := v.Type()
		for i := 0; i < v.NumField(); i++ {
			field := t.Field(i)
			if field.PkgPath != "" {
				continue
			}
			out[camelCommunityField(field.Name)] = toCommunityWireValue(v.Field(i))
		}
		return out
	case reflect.Slice, reflect.Array:
		out := make([]interface{}, v.Len())
		for i := 0; i < v.Len(); i++ {
			out[i] = toCommunityWireValue(v.Index(i))
		}
		return out
	case reflect.Map:
		if v.IsNil() {
			return nil
		}
		out := make(map[string]interface{})
		iter := v.MapRange()
		for iter.Next() {
			key := iter.Key()
			if key.Kind() != reflect.String {
				continue
			}
			out[key.String()] = toCommunityWireValue(iter.Value())
		}
		return out
	default:
		return v.Interface()
	}
}

func camelCommunityField(name string) string {
	if name == "ID" {
		return "id"
	}
	if strings.HasSuffix(name, "ID") {
		name = strings.TrimSuffix(name, "ID") + "Id"
	}
	if strings.HasSuffix(name, "URL") {
		name = strings.TrimSuffix(name, "URL") + "Url"
	}
	if name == "EventTicketInfo" {
		return "eventTicketInfo"
	}
	if name == "TicketInfo" {
		return "ticketInfo"
	}
	if name == "IsPrivate" || name == "IsVerified" || name == "IsJoined" {
		return strings.ToLower(name[:2]) + name[2:]
	}
	first := true
	return strings.Map(func(r rune) rune {
		if first {
			first = false
			return unicode.ToLower(r)
		}
		return r
	}, name)
}

func (v Community) MarshalJSON() ([]byte, error) {
	wire := toCommunityWireValue(reflect.ValueOf(v)).(map[string]interface{})
	wire["isJoined"] = false
	wire["userRole"] = "member"
	return json.Marshal(wire)
}

func (v CommunityMember) MarshalJSON() ([]byte, error) {
	wire := toCommunityWireValue(reflect.ValueOf(v)).(map[string]interface{})
	wire["username"] = ""
	wire["avatarUrl"] = nil
	wire["lastActiveAt"] = v.JoinedAt
	return json.Marshal(wire)
}

func (v ThreadReply) MarshalJSON() ([]byte, error) {
	wire := toCommunityWireValue(reflect.ValueOf(v)).(map[string]interface{})
	wire["authorName"] = ""
	wire["authorAvatar"] = nil
	return json.Marshal(wire)
}

func (v Thread) MarshalJSON() ([]byte, error) {
	wire := toCommunityWireValue(reflect.ValueOf(v)).(map[string]interface{})
	wire["authorName"] = ""
	wire["authorAvatar"] = nil
	return json.Marshal(wire)
}

func (v ContentReport) MarshalJSON() ([]byte, error) {
	wire := toCommunityWireValue(reflect.ValueOf(v)).(map[string]interface{})
	wire["reporterName"] = ""
	return json.Marshal(wire)
}

func (v Ticket) MarshalJSON() ([]byte, error)            { return marshalCommunityWire(v) }
func (v Subscription) MarshalJSON() ([]byte, error)     { return marshalCommunityWire(v) }
func (v Guideline) MarshalJSON() ([]byte, error)         { return marshalCommunityWire(v) }
func (v Collective) MarshalJSON() ([]byte, error)        { return marshalCommunityWire(v) }
func (v CollectiveStats) MarshalJSON() ([]byte, error)   { return marshalCommunityWire(v) }
func (v CommunitySettings) MarshalJSON() ([]byte, error) { return marshalCommunityWire(v) }
func (v CommunityStats) MarshalJSON() ([]byte, error)    { return marshalCommunityWire(v) }
func (v Event) MarshalJSON() ([]byte, error)             { return marshalCommunityWire(v) }
func (v EventTicketInfo) MarshalJSON() ([]byte, error)   { return marshalCommunityWire(v) }
func (v MemberPreferences) MarshalJSON() ([]byte, error) { return marshalCommunityWire(v) }
