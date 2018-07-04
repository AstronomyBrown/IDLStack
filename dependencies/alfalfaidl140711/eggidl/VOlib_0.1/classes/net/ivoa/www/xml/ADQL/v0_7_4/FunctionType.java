/**
 * FunctionType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public abstract class FunctionType  extends net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType  implements java.io.Serializable {
    private net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType allow;
    private net.ivoa.www.xml.ADQL.v0_7_4.SelectionItemType arg;

    public FunctionType() {
    }


    /**
     * Gets the allow value for this FunctionType.
     * 
     * @return allow
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType getAllow() {
        return allow;
    }


    /**
     * Sets the allow value for this FunctionType.
     * 
     * @param allow
     */
    public void setAllow(net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType allow) {
        this.allow = allow;
    }


    /**
     * Gets the arg value for this FunctionType.
     * 
     * @return arg
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.SelectionItemType getArg() {
        return arg;
    }


    /**
     * Sets the arg value for this FunctionType.
     * 
     * @param arg
     */
    public void setArg(net.ivoa.www.xml.ADQL.v0_7_4.SelectionItemType arg) {
        this.arg = arg;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FunctionType)) return false;
        FunctionType other = (FunctionType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.allow==null && other.getAllow()==null) || 
             (this.allow!=null &&
              this.allow.equals(other.getAllow()))) &&
            ((this.arg==null && other.getArg()==null) || 
             (this.arg!=null &&
              this.arg.equals(other.getArg())));
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
        if (getAllow() != null) {
            _hashCode += getAllow().hashCode();
        }
        if (getArg() != null) {
            _hashCode += getArg().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FunctionType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "functionType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("allow");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Allow"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionOptionType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("arg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Arg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionItemType"));
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
