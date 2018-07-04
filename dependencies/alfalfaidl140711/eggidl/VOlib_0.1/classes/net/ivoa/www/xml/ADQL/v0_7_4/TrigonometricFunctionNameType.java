/**
 * TrigonometricFunctionNameType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class TrigonometricFunctionNameType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected TrigonometricFunctionNameType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _SIN = "SIN";
    public static final java.lang.String _COS = "COS";
    public static final java.lang.String _TAN = "TAN";
    public static final java.lang.String _COT = "COT";
    public static final java.lang.String _ASIN = "ASIN";
    public static final java.lang.String _ACOS = "ACOS";
    public static final java.lang.String _ATAN = "ATAN";
    public static final java.lang.String _ATAN2 = "ATAN2";
    public static final TrigonometricFunctionNameType SIN = new TrigonometricFunctionNameType(_SIN);
    public static final TrigonometricFunctionNameType COS = new TrigonometricFunctionNameType(_COS);
    public static final TrigonometricFunctionNameType TAN = new TrigonometricFunctionNameType(_TAN);
    public static final TrigonometricFunctionNameType COT = new TrigonometricFunctionNameType(_COT);
    public static final TrigonometricFunctionNameType ASIN = new TrigonometricFunctionNameType(_ASIN);
    public static final TrigonometricFunctionNameType ACOS = new TrigonometricFunctionNameType(_ACOS);
    public static final TrigonometricFunctionNameType ATAN = new TrigonometricFunctionNameType(_ATAN);
    public static final TrigonometricFunctionNameType ATAN2 = new TrigonometricFunctionNameType(_ATAN2);
    public java.lang.String getValue() { return _value_;}
    public static TrigonometricFunctionNameType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        TrigonometricFunctionNameType enumeration = (TrigonometricFunctionNameType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static TrigonometricFunctionNameType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(TrigonometricFunctionNameType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "trigonometricFunctionNameType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
