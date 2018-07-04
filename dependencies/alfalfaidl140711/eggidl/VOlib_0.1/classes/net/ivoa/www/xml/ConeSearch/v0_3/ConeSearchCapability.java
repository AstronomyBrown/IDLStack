/**
 * ConeSearchCapability.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ConeSearch.v0_3;

public class ConeSearchCapability  extends net.ivoa.www.xml.ConeSearch.v0_3.CSCapRestriction  implements java.io.Serializable {
    private float maxSR;
    private int maxRecords;
    private boolean verbosity;

    public ConeSearchCapability() {
    }


    /**
     * Gets the maxSR value for this ConeSearchCapability.
     * 
     * @return maxSR
     */
    public float getMaxSR() {
        return maxSR;
    }


    /**
     * Sets the maxSR value for this ConeSearchCapability.
     * 
     * @param maxSR
     */
    public void setMaxSR(float maxSR) {
        this.maxSR = maxSR;
    }


    /**
     * Gets the maxRecords value for this ConeSearchCapability.
     * 
     * @return maxRecords
     */
    public int getMaxRecords() {
        return maxRecords;
    }


    /**
     * Sets the maxRecords value for this ConeSearchCapability.
     * 
     * @param maxRecords
     */
    public void setMaxRecords(int maxRecords) {
        this.maxRecords = maxRecords;
    }


    /**
     * Gets the verbosity value for this ConeSearchCapability.
     * 
     * @return verbosity
     */
    public boolean isVerbosity() {
        return verbosity;
    }


    /**
     * Sets the verbosity value for this ConeSearchCapability.
     * 
     * @param verbosity
     */
    public void setVerbosity(boolean verbosity) {
        this.verbosity = verbosity;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ConeSearchCapability)) return false;
        ConeSearchCapability other = (ConeSearchCapability) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            this.maxSR == other.getMaxSR() &&
            this.maxRecords == other.getMaxRecords() &&
            this.verbosity == other.isVerbosity();
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
        _hashCode += new Float(getMaxSR()).hashCode();
        _hashCode += getMaxRecords();
        _hashCode += (isVerbosity() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ConeSearchCapability.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "ConeSearchCapability"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxSR");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "maxSR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "float"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxRecords");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "maxRecords"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("verbosity");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "verbosity"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
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
