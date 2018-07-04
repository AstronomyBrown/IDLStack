/**
 * LikePredType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class LikePredType  extends net.ivoa.www.xml.ADQL.v0_7_4.SearchType  implements java.io.Serializable {
    private net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType arg;
    private net.ivoa.www.xml.ADQL.v0_7_4.AtomType pattern;

    public LikePredType() {
    }


    /**
     * Gets the arg value for this LikePredType.
     * 
     * @return arg
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType getArg() {
        return arg;
    }


    /**
     * Sets the arg value for this LikePredType.
     * 
     * @param arg
     */
    public void setArg(net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType arg) {
        this.arg = arg;
    }


    /**
     * Gets the pattern value for this LikePredType.
     * 
     * @return pattern
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.AtomType getPattern() {
        return pattern;
    }


    /**
     * Sets the pattern value for this LikePredType.
     * 
     * @param pattern
     */
    public void setPattern(net.ivoa.www.xml.ADQL.v0_7_4.AtomType pattern) {
        this.pattern = pattern;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof LikePredType)) return false;
        LikePredType other = (LikePredType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.arg==null && other.getArg()==null) || 
             (this.arg!=null &&
              this.arg.equals(other.getArg()))) &&
            ((this.pattern==null && other.getPattern()==null) || 
             (this.pattern!=null &&
              this.pattern.equals(other.getPattern())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getArg() != null) {
            _hashCode += getArg().hashCode();
        }
        if (getPattern() != null) {
            _hashCode += getPattern().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(LikePredType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "likePredType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("arg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Arg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "scalarExpressionType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pattern");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Pattern"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "atomType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
