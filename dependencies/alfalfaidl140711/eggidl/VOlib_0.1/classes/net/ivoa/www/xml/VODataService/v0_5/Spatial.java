/**
 * Spatial.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class Spatial  implements java.io.Serializable {
    private net.ivoa.www.xml.VODataService.v0_5.Region[] region;
    private java.lang.Float resolution;
    private java.lang.Float regionOfRegard;

    public Spatial() {
    }


    /**
     * Gets the region value for this Spatial.
     * 
     * @return region
     */
    public net.ivoa.www.xml.VODataService.v0_5.Region[] getRegion() {
        return region;
    }


    /**
     * Sets the region value for this Spatial.
     * 
     * @param region
     */
    public void setRegion(net.ivoa.www.xml.VODataService.v0_5.Region[] region) {
        this.region = region;
    }

    public net.ivoa.www.xml.VODataService.v0_5.Region getRegion(int i) {
        return this.region[i];
    }

    public void setRegion(int i, net.ivoa.www.xml.VODataService.v0_5.Region value) {
        this.region[i] = value;
    }


    /**
     * Gets the resolution value for this Spatial.
     * 
     * @return resolution
     */
    public java.lang.Float getResolution() {
        return resolution;
    }


    /**
     * Sets the resolution value for this Spatial.
     * 
     * @param resolution
     */
    public void setResolution(java.lang.Float resolution) {
        this.resolution = resolution;
    }


    /**
     * Gets the regionOfRegard value for this Spatial.
     * 
     * @return regionOfRegard
     */
    public java.lang.Float getRegionOfRegard() {
        return regionOfRegard;
    }


    /**
     * Sets the regionOfRegard value for this Spatial.
     * 
     * @param regionOfRegard
     */
    public void setRegionOfRegard(java.lang.Float regionOfRegard) {
        this.regionOfRegard = regionOfRegard;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Spatial)) return false;
        Spatial other = (Spatial) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.region==null && other.getRegion()==null) || 
             (this.region!=null &&
              java.util.Arrays.equals(this.region, other.getRegion()))) &&
            ((this.resolution==null && other.getResolution()==null) || 
             (this.resolution!=null &&
              this.resolution.equals(other.getResolution()))) &&
            ((this.regionOfRegard==null && other.getRegionOfRegard()==null) || 
             (this.regionOfRegard!=null &&
              this.regionOfRegard.equals(other.getRegionOfRegard())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getRegion() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRegion());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRegion(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getResolution() != null) {
            _hashCode += getResolution().hashCode();
        }
        if (getRegionOfRegard() != null) {
            _hashCode += getRegionOfRegard().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Spatial.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spatial"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("region");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "region"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Region"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resolution");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "resolution"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "float"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("regionOfRegard");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "regionOfRegard"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "float"));
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
