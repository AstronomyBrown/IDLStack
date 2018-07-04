/**
 * AstronTimeTypeReferenceTime_base.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class AstronTimeTypeReferenceTime_base implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected AstronTimeTypeReferenceTime_base(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _ISO8601 = "ISO8601";
    public static final java.lang.String _JD = "JD";
    public static final java.lang.String _MJD = "MJD";
    public static final java.lang.String _relative = "relative";
    public static final AstronTimeTypeReferenceTime_base ISO8601 = new AstronTimeTypeReferenceTime_base(_ISO8601);
    public static final AstronTimeTypeReferenceTime_base JD = new AstronTimeTypeReferenceTime_base(_JD);
    public static final AstronTimeTypeReferenceTime_base MJD = new AstronTimeTypeReferenceTime_base(_MJD);
    public static final AstronTimeTypeReferenceTime_base relative = new AstronTimeTypeReferenceTime_base(_relative);
    public java.lang.String getValue() { return _value_;}
    public static AstronTimeTypeReferenceTime_base fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        AstronTimeTypeReferenceTime_base enumeration = (AstronTimeTypeReferenceTime_base)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static AstronTimeTypeReferenceTime_base fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(AstronTimeTypeReferenceTime_base.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReferenceTime_base"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
