/**
 * ComparisonType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class ComparisonType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected ComparisonType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _value1 = "=";
    public static final java.lang.String _value2 = "<>";
    public static final java.lang.String _value3 = ">";
    public static final java.lang.String _value4 = ">=";
    public static final java.lang.String _value5 = "<";
    public static final java.lang.String _value6 = "<=";
    public static final ComparisonType value1 = new ComparisonType(_value1);
    public static final ComparisonType value2 = new ComparisonType(_value2);
    public static final ComparisonType value3 = new ComparisonType(_value3);
    public static final ComparisonType value4 = new ComparisonType(_value4);
    public static final ComparisonType value5 = new ComparisonType(_value5);
    public static final ComparisonType value6 = new ComparisonType(_value6);
    public java.lang.String getValue() { return _value_;}
    public static ComparisonType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        ComparisonType enumeration = (ComparisonType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static ComparisonType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(ComparisonType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "comparisonType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
