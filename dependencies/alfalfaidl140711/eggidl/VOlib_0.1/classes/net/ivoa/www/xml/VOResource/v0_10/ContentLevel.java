/**
 * ContentLevel.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class ContentLevel implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected ContentLevel(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _value1 = "General";
    public static final java.lang.String _value2 = "Elementary Education";
    public static final java.lang.String _value3 = "Middle School Education";
    public static final java.lang.String _value4 = "Secondary Education";
    public static final java.lang.String _value5 = "Community College";
    public static final java.lang.String _value6 = "University";
    public static final java.lang.String _value7 = "Research";
    public static final java.lang.String _value8 = "Amateur";
    public static final java.lang.String _value9 = "Informal Education";
    public static final ContentLevel value1 = new ContentLevel(_value1);
    public static final ContentLevel value2 = new ContentLevel(_value2);
    public static final ContentLevel value3 = new ContentLevel(_value3);
    public static final ContentLevel value4 = new ContentLevel(_value4);
    public static final ContentLevel value5 = new ContentLevel(_value5);
    public static final ContentLevel value6 = new ContentLevel(_value6);
    public static final ContentLevel value7 = new ContentLevel(_value7);
    public static final ContentLevel value8 = new ContentLevel(_value8);
    public static final ContentLevel value9 = new ContentLevel(_value9);
    public java.lang.String getValue() { return _value_;}
    public static ContentLevel fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        ContentLevel enumeration = (ContentLevel)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static ContentLevel fromString(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        return fromValue(value);
    }
    public boolean equals(java.lang.Object obj) {return (obj == this);}
    public int hashCode() { return toString().hashCode();}
    public java.lang.String toString() { return _value_;}
    public java.lang.Object readResolve() throws java.io.ObjectStreamException { return fromValue(_value_);}
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumSerializer(
            _javaType, _xmlType);
    }
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumDeserializer(
            _javaType, _xmlType);
    }
    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ContentLevel.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ContentLevel"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
