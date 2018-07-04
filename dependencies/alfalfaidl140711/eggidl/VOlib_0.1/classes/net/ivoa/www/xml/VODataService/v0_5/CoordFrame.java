/**
 * CoordFrame.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class CoordFrame implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected CoordFrame(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _ICRS = "ICRS";
    public static final java.lang.String _FK5 = "FK5";
    public static final java.lang.String _FK4 = "FK4";
    public static final java.lang.String _ECL = "ECL";
    public static final java.lang.String _GAL = "GAL";
    public static final java.lang.String _SGAL = "SGAL";
    public static final CoordFrame ICRS = new CoordFrame(_ICRS);
    public static final CoordFrame FK5 = new CoordFrame(_FK5);
    public static final CoordFrame FK4 = new CoordFrame(_FK4);
    public static final CoordFrame ECL = new CoordFrame(_ECL);
    public static final CoordFrame GAL = new CoordFrame(_GAL);
    public static final CoordFrame SGAL = new CoordFrame(_SGAL);
    public java.lang.String getValue() { return _value_;}
    public static CoordFrame fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        CoordFrame enumeration = (CoordFrame)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static CoordFrame fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(CoordFrame.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordFrame"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
