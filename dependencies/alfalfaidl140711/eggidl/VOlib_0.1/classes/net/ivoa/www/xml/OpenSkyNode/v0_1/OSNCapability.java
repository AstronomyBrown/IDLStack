/**
 * OSNCapability.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.OpenSkyNode.v0_1;

public class OSNCapability  extends net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapRestriction  implements java.io.Serializable {
    private java.lang.String compliance;
    private double latitude;
    private double longitude;
    private long maxRecords;
    private java.lang.String primaryTable;
    private java.lang.String primaryKey;

    public OSNCapability() {
    }


    /**
     * Gets the compliance value for this OSNCapability.
     * 
     * @return compliance
     */
    public java.lang.String getCompliance() {
        return compliance;
    }


    /**
     * Sets the compliance value for this OSNCapability.
     * 
     * @param compliance
     */
    public void setCompliance(java.lang.String compliance) {
        this.compliance = compliance;
    }


    /**
     * Gets the latitude value for this OSNCapability.
     * 
     * @return latitude
     */
    public double getLatitude() {
        return latitude;
    }


    /**
     * Sets the latitude value for this OSNCapability.
     * 
     * @param latitude
     */
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }


    /**
     * Gets the longitude value for this OSNCapability.
     * 
     * @return longitude
     */
    public double getLongitude() {
        return longitude;
    }


    /**
     * Sets the longitude value for this OSNCapability.
     * 
     * @param longitude
     */
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }


    /**
     * Gets the maxRecords value for this OSNCapability.
     * 
     * @return maxRecords
     */
    public long getMaxRecords() {
        return maxRecords;
    }


    /**
     * Sets the maxRecords value for this OSNCapability.
     * 
     * @param maxRecords
     */
    public void setMaxRecords(long maxRecords) {
        this.maxRecords = maxRecords;
    }


    /**
     * Gets the primaryTable value for this OSNCapability.
     * 
     * @return primaryTable
     */
    public java.lang.String getPrimaryTable() {
        return primaryTable;
    }


    /**
     * Sets the primaryTable value for this OSNCapability.
     * 
     * @param primaryTable
     */
    public void setPrimaryTable(java.lang.String primaryTable) {
        this.primaryTable = primaryTable;
    }


    /**
     * Gets the primaryKey value for this OSNCapability.
     * 
     * @return primaryKey
     */
    public java.lang.String getPrimaryKey() {
        return primaryKey;
    }


    /**
     * Sets the primaryKey value for this OSNCapability.
     * 
     * @param primaryKey
     */
    public void setPrimaryKey(java.lang.String primaryKey) {
        this.primaryKey = primaryKey;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof OSNCapability)) return false;
        OSNCapability other = (OSNCapability) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.compliance==null && other.getCompliance()==null) || 
             (this.compliance!=null &&
              this.compliance.equals(other.getCompliance()))) &&
            this.latitude == other.getLatitude() &&
            this.longitude == other.getLongitude() &&
            this.maxRecords == other.getMaxRecords() &&
            ((this.primaryTable==null && other.getPrimaryTable()==null) || 
             (this.primaryTable!=null &&
              this.primaryTable.equals(other.getPrimaryTable()))) &&
            ((this.primaryKey==null && other.getPrimaryKey()==null) || 
             (this.primaryKey!=null &&
              this.primaryKey.equals(other.getPrimaryKey())));
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
        if (getCompliance() != null) {
            _hashCode += getCompliance().hashCode();
        }
        _hashCode += new Double(getLatitude()).hashCode();
        _hashCode += new Double(getLongitude()).hashCode();
        _hashCode += new Long(getMaxRecords()).hashCode();
        if (getPrimaryTable() != null) {
            _hashCode += getPrimaryTable().hashCode();
        }
        if (getPrimaryKey() != null) {
            _hashCode += getPrimaryKey().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(OSNCapability.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OSNCapability"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("compliance");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "Compliance"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("latitude");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "Latitude"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("longitude");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "Longitude"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxRecords");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "MaxRecords"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("primaryTable");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "PrimaryTable"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("primaryKey");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "PrimaryKey"));
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
