/**
 * ServiceSimpleImageAccess.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ServiceSimpleImageAccess  extends org.us_vo.www.DBResource  implements java.io.Serializable {
    private java.lang.String imageServiceType;
    private double maxQueryRegionSizeLong;
    private double maxQueryRegionSizeLat;
    private double maxImageExtentLong;
    private double maxImageExtentLat;
    private int maxImageSizeLong;
    private int maxImageSizeLat;
    private long maxFileSize;
    private long maxRecords;
    private org.us_vo.www.ArrayOfString format;
    private java.lang.String VOTableColumns;

    public ServiceSimpleImageAccess() {
    }


    /**
     * Gets the imageServiceType value for this ServiceSimpleImageAccess.
     * 
     * @return imageServiceType
     */
    public java.lang.String getImageServiceType() {
        return imageServiceType;
    }


    /**
     * Sets the imageServiceType value for this ServiceSimpleImageAccess.
     * 
     * @param imageServiceType
     */
    public void setImageServiceType(java.lang.String imageServiceType) {
        this.imageServiceType = imageServiceType;
    }


    /**
     * Gets the maxQueryRegionSizeLong value for this ServiceSimpleImageAccess.
     * 
     * @return maxQueryRegionSizeLong
     */
    public double getMaxQueryRegionSizeLong() {
        return maxQueryRegionSizeLong;
    }


    /**
     * Sets the maxQueryRegionSizeLong value for this ServiceSimpleImageAccess.
     * 
     * @param maxQueryRegionSizeLong
     */
    public void setMaxQueryRegionSizeLong(double maxQueryRegionSizeLong) {
        this.maxQueryRegionSizeLong = maxQueryRegionSizeLong;
    }


    /**
     * Gets the maxQueryRegionSizeLat value for this ServiceSimpleImageAccess.
     * 
     * @return maxQueryRegionSizeLat
     */
    public double getMaxQueryRegionSizeLat() {
        return maxQueryRegionSizeLat;
    }


    /**
     * Sets the maxQueryRegionSizeLat value for this ServiceSimpleImageAccess.
     * 
     * @param maxQueryRegionSizeLat
     */
    public void setMaxQueryRegionSizeLat(double maxQueryRegionSizeLat) {
        this.maxQueryRegionSizeLat = maxQueryRegionSizeLat;
    }


    /**
     * Gets the maxImageExtentLong value for this ServiceSimpleImageAccess.
     * 
     * @return maxImageExtentLong
     */
    public double getMaxImageExtentLong() {
        return maxImageExtentLong;
    }


    /**
     * Sets the maxImageExtentLong value for this ServiceSimpleImageAccess.
     * 
     * @param maxImageExtentLong
     */
    public void setMaxImageExtentLong(double maxImageExtentLong) {
        this.maxImageExtentLong = maxImageExtentLong;
    }


    /**
     * Gets the maxImageExtentLat value for this ServiceSimpleImageAccess.
     * 
     * @return maxImageExtentLat
     */
    public double getMaxImageExtentLat() {
        return maxImageExtentLat;
    }


    /**
     * Sets the maxImageExtentLat value for this ServiceSimpleImageAccess.
     * 
     * @param maxImageExtentLat
     */
    public void setMaxImageExtentLat(double maxImageExtentLat) {
        this.maxImageExtentLat = maxImageExtentLat;
    }


    /**
     * Gets the maxImageSizeLong value for this ServiceSimpleImageAccess.
     * 
     * @return maxImageSizeLong
     */
    public int getMaxImageSizeLong() {
        return maxImageSizeLong;
    }


    /**
     * Sets the maxImageSizeLong value for this ServiceSimpleImageAccess.
     * 
     * @param maxImageSizeLong
     */
    public void setMaxImageSizeLong(int maxImageSizeLong) {
        this.maxImageSizeLong = maxImageSizeLong;
    }


    /**
     * Gets the maxImageSizeLat value for this ServiceSimpleImageAccess.
     * 
     * @return maxImageSizeLat
     */
    public int getMaxImageSizeLat() {
        return maxImageSizeLat;
    }


    /**
     * Sets the maxImageSizeLat value for this ServiceSimpleImageAccess.
     * 
     * @param maxImageSizeLat
     */
    public void setMaxImageSizeLat(int maxImageSizeLat) {
        this.maxImageSizeLat = maxImageSizeLat;
    }


    /**
     * Gets the maxFileSize value for this ServiceSimpleImageAccess.
     * 
     * @return maxFileSize
     */
    public long getMaxFileSize() {
        return maxFileSize;
    }


    /**
     * Sets the maxFileSize value for this ServiceSimpleImageAccess.
     * 
     * @param maxFileSize
     */
    public void setMaxFileSize(long maxFileSize) {
        this.maxFileSize = maxFileSize;
    }


    /**
     * Gets the maxRecords value for this ServiceSimpleImageAccess.
     * 
     * @return maxRecords
     */
    public long getMaxRecords() {
        return maxRecords;
    }


    /**
     * Sets the maxRecords value for this ServiceSimpleImageAccess.
     * 
     * @param maxRecords
     */
    public void setMaxRecords(long maxRecords) {
        this.maxRecords = maxRecords;
    }


    /**
     * Gets the format value for this ServiceSimpleImageAccess.
     * 
     * @return format
     */
    public org.us_vo.www.ArrayOfString getFormat() {
        return format;
    }


    /**
     * Sets the format value for this ServiceSimpleImageAccess.
     * 
     * @param format
     */
    public void setFormat(org.us_vo.www.ArrayOfString format) {
        this.format = format;
    }


    /**
     * Gets the VOTableColumns value for this ServiceSimpleImageAccess.
     * 
     * @return VOTableColumns
     */
    public java.lang.String getVOTableColumns() {
        return VOTableColumns;
    }


    /**
     * Sets the VOTableColumns value for this ServiceSimpleImageAccess.
     * 
     * @param VOTableColumns
     */
    public void setVOTableColumns(java.lang.String VOTableColumns) {
        this.VOTableColumns = VOTableColumns;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ServiceSimpleImageAccess)) return false;
        ServiceSimpleImageAccess other = (ServiceSimpleImageAccess) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.imageServiceType==null && other.getImageServiceType()==null) || 
             (this.imageServiceType!=null &&
              this.imageServiceType.equals(other.getImageServiceType()))) &&
            this.maxQueryRegionSizeLong == other.getMaxQueryRegionSizeLong() &&
            this.maxQueryRegionSizeLat == other.getMaxQueryRegionSizeLat() &&
            this.maxImageExtentLong == other.getMaxImageExtentLong() &&
            this.maxImageExtentLat == other.getMaxImageExtentLat() &&
            this.maxImageSizeLong == other.getMaxImageSizeLong() &&
            this.maxImageSizeLat == other.getMaxImageSizeLat() &&
            this.maxFileSize == other.getMaxFileSize() &&
            this.maxRecords == other.getMaxRecords() &&
            ((this.format==null && other.getFormat()==null) || 
             (this.format!=null &&
              this.format.equals(other.getFormat()))) &&
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
        if (getImageServiceType() != null) {
            _hashCode += getImageServiceType().hashCode();
        }
        _hashCode += new Double(getMaxQueryRegionSizeLong()).hashCode();
        _hashCode += new Double(getMaxQueryRegionSizeLat()).hashCode();
        _hashCode += new Double(getMaxImageExtentLong()).hashCode();
        _hashCode += new Double(getMaxImageExtentLat()).hashCode();
        _hashCode += getMaxImageSizeLong();
        _hashCode += getMaxImageSizeLat();
        _hashCode += new Long(getMaxFileSize()).hashCode();
        _hashCode += new Long(getMaxRecords()).hashCode();
        if (getFormat() != null) {
            _hashCode += getFormat().hashCode();
        }
        if (getVOTableColumns() != null) {
            _hashCode += getVOTableColumns().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ServiceSimpleImageAccess.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceSimpleImageAccess"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageServiceType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ImageServiceType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxQueryRegionSizeLong");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxQueryRegionSizeLong"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxQueryRegionSizeLat");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxQueryRegionSizeLat"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageExtentLong");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxImageExtentLong"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageExtentLat");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxImageExtentLat"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageSizeLong");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxImageSizeLong"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageSizeLat");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxImageSizeLat"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxFileSize");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxFileSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxRecords");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "MaxRecords"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("format");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Format"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        elemField.setMinOccurs(0);
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
