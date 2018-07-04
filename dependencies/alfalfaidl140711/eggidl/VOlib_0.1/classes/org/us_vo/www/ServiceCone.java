/**
 * ServiceCone.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ServiceCone  extends org.us_vo.www.DBResource  implements java.io.Serializable {
    private double maxSearchRadius;
    private long maxRecords;
    private java.lang.String VOTableColumns;

    public ServiceCone() {
    }


    /**
     * Gets the maxSearchRadius value for this ServiceCone.
     * 
     * @return maxSearchRadius
     */
    public double getMaxSearchRadius() {
        return maxSearchRadius;
    }


    /**
     * Sets the maxSearchRadius value for this ServiceCone.
     * 
     * @param maxSearchRadius
     */
    public void setMaxSearchRadius(double maxSearchRadius) {
        this.maxSearchRadius = maxSearchRadius;
    }


    /**
     * Gets the maxRecords value for this ServiceCone.
     * 
     * @return maxRecords
     */
    public long getMaxRecords() {
        return maxRecords;
    }


    /**
     * Sets the maxRecords value for this ServiceCone.
     * 
     * @param maxRecords
     */
    public void setMaxRecords(long maxRecords) {
        this.maxRecords = maxRecords;
    }


    /**
     * Gets the VOTableColumns value for this ServiceCone.
     * 
     * @return VOTableColumns
     */
    public java.lang.String getVOTableColumns() {
        return VOTableColumns;
    }


    /**
     * Sets the VOTableColumns value for this ServiceCone.
     * 
     * @param VOTableColumns
     */
    public void setVOTableColumns(java.lang.String VOTableColumns) {
        this.VOTableColumns = VOTableColumns;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ServiceCone)) return false;
        ServiceCone other = (ServiceCone) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            this.maxSearchRadius == other.getMaxSearchRadius() &&
            this.maxRecords == other.getMaxRecords() &&
            ((this.VOTableColumns==null && other.getVOTableColumns()==null) || 
             (this.VOTableColumns!=null &&
              this.VOTableColumns.equals(other.getVOTableColumns())));
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
        _hashCode += new Double(getMaxSearchRadius()).hashCode();
        _hashCode += new Long(getMaxRecords()).hashCode();
        if (getVOTableColumns() != null) {
            _hashCode += getVOTableColumns().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ServiceCone.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceCone"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxSearchRadius");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxSearchRadius"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxRecords");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxRecords"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VOTableColumns");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "VOTableColumns"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
