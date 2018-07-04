/**
 * SIACapability.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.SIA.v0_7;

public class SIACapability  extends net.ivoa.www.xml.SIA.v0_7.SIACapRestriction  implements java.io.Serializable {
    private net.ivoa.www.xml.SIA.v0_7.ImageServiceType imageServiceType;
    private net.ivoa.www.xml.SIA.v0_7.SkySize maxQueryRegionSize;
    private net.ivoa.www.xml.SIA.v0_7.SkySize maxImageExtent;
    private net.ivoa.www.xml.SIA.v0_7.ImageSize maxImageSize;
    private int maxFileSize;
    private int maxRecords;

    public SIACapability() {
    }


    /**
     * Gets the imageServiceType value for this SIACapability.
     * 
     * @return imageServiceType
     */
    public net.ivoa.www.xml.SIA.v0_7.ImageServiceType getImageServiceType() {
        return imageServiceType;
    }


    /**
     * Sets the imageServiceType value for this SIACapability.
     * 
     * @param imageServiceType
     */
    public void setImageServiceType(net.ivoa.www.xml.SIA.v0_7.ImageServiceType imageServiceType) {
        this.imageServiceType = imageServiceType;
    }


    /**
     * Gets the maxQueryRegionSize value for this SIACapability.
     * 
     * @return maxQueryRegionSize
     */
    public net.ivoa.www.xml.SIA.v0_7.SkySize getMaxQueryRegionSize() {
        return maxQueryRegionSize;
    }


    /**
     * Sets the maxQueryRegionSize value for this SIACapability.
     * 
     * @param maxQueryRegionSize
     */
    public void setMaxQueryRegionSize(net.ivoa.www.xml.SIA.v0_7.SkySize maxQueryRegionSize) {
        this.maxQueryRegionSize = maxQueryRegionSize;
    }


    /**
     * Gets the maxImageExtent value for this SIACapability.
     * 
     * @return maxImageExtent
     */
    public net.ivoa.www.xml.SIA.v0_7.SkySize getMaxImageExtent() {
        return maxImageExtent;
    }


    /**
     * Sets the maxImageExtent value for this SIACapability.
     * 
     * @param maxImageExtent
     */
    public void setMaxImageExtent(net.ivoa.www.xml.SIA.v0_7.SkySize maxImageExtent) {
        this.maxImageExtent = maxImageExtent;
    }


    /**
     * Gets the maxImageSize value for this SIACapability.
     * 
     * @return maxImageSize
     */
    public net.ivoa.www.xml.SIA.v0_7.ImageSize getMaxImageSize() {
        return maxImageSize;
    }


    /**
     * Sets the maxImageSize value for this SIACapability.
     * 
     * @param maxImageSize
     */
    public void setMaxImageSize(net.ivoa.www.xml.SIA.v0_7.ImageSize maxImageSize) {
        this.maxImageSize = maxImageSize;
    }


    /**
     * Gets the maxFileSize value for this SIACapability.
     * 
     * @return maxFileSize
     */
    public int getMaxFileSize() {
        return maxFileSize;
    }


    /**
     * Sets the maxFileSize value for this SIACapability.
     * 
     * @param maxFileSize
     */
    public void setMaxFileSize(int maxFileSize) {
        this.maxFileSize = maxFileSize;
    }


    /**
     * Gets the maxRecords value for this SIACapability.
     * 
     * @return maxRecords
     */
    public int getMaxRecords() {
        return maxRecords;
    }


    /**
     * Sets the maxRecords value for this SIACapability.
     * 
     * @param maxRecords
     */
    public void setMaxRecords(int maxRecords) {
        this.maxRecords = maxRecords;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SIACapability)) return false;
        SIACapability other = (SIACapability) obj;
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
            ((this.maxQueryRegionSize==null && other.getMaxQueryRegionSize()==null) || 
             (this.maxQueryRegionSize!=null &&
              this.maxQueryRegionSize.equals(other.getMaxQueryRegionSize()))) &&
            ((this.maxImageExtent==null && other.getMaxImageExtent()==null) || 
             (this.maxImageExtent!=null &&
              this.maxImageExtent.equals(other.getMaxImageExtent()))) &&
            ((this.maxImageSize==null && other.getMaxImageSize()==null) || 
             (this.maxImageSize!=null &&
              this.maxImageSize.equals(other.getMaxImageSize()))) &&
            this.maxFileSize == other.getMaxFileSize() &&
            this.maxRecords == other.getMaxRecords();
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
        if (getMaxQueryRegionSize() != null) {
            _hashCode += getMaxQueryRegionSize().hashCode();
        }
        if (getMaxImageExtent() != null) {
            _hashCode += getMaxImageExtent().hashCode();
        }
        if (getMaxImageSize() != null) {
            _hashCode += getMaxImageSize().hashCode();
        }
        _hashCode += getMaxFileSize();
        _hashCode += getMaxRecords();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SIACapability.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SIACapability"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageServiceType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "imageServiceType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "ImageServiceType"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxQueryRegionSize");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "maxQueryRegionSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SkySize"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageExtent");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "maxImageExtent"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SkySize"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxImageSize");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "maxImageSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "ImageSize"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxFileSize");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "maxFileSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("maxRecords");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "maxRecords"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
