/**
 * Coverage.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class Coverage  implements java.io.Serializable {
    private net.ivoa.www.xml.VODataService.v0_5.Spatial spatial;
    private net.ivoa.www.xml.VODataService.v0_5.Spectral spectral;
    private net.ivoa.www.xml.VODataService.v0_5.Temporal temporal;

    public Coverage() {
    }


    /**
     * Gets the spatial value for this Coverage.
     * 
     * @return spatial
     */
    public net.ivoa.www.xml.VODataService.v0_5.Spatial getSpatial() {
        return spatial;
    }


    /**
     * Sets the spatial value for this Coverage.
     * 
     * @param spatial
     */
    public void setSpatial(net.ivoa.www.xml.VODataService.v0_5.Spatial spatial) {
        this.spatial = spatial;
    }


    /**
     * Gets the spectral value for this Coverage.
     * 
     * @return spectral
     */
    public net.ivoa.www.xml.VODataService.v0_5.Spectral getSpectral() {
        return spectral;
    }


    /**
     * Sets the spectral value for this Coverage.
     * 
     * @param spectral
     */
    public void setSpectral(net.ivoa.www.xml.VODataService.v0_5.Spectral spectral) {
        this.spectral = spectral;
    }


    /**
     * Gets the temporal value for this Coverage.
     * 
     * @return temporal
     */
    public net.ivoa.www.xml.VODataService.v0_5.Temporal getTemporal() {
        return temporal;
    }


    /**
     * Sets the temporal value for this Coverage.
     * 
     * @param temporal
     */
    public void setTemporal(net.ivoa.www.xml.VODataService.v0_5.Temporal temporal) {
        this.temporal = temporal;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Coverage)) return false;
        Coverage other = (Coverage) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.spatial==null && other.getSpatial()==null) || 
             (this.spatial!=null &&
              this.spatial.equals(other.getSpatial()))) &&
            ((this.spectral==null && other.getSpectral()==null) || 
             (this.spectral!=null &&
              this.spectral.equals(other.getSpectral()))) &&
            ((this.temporal==null && other.getTemporal()==null) || 
             (this.temporal!=null &&
              this.temporal.equals(other.getTemporal())));
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
        if (getSpatial() != null) {
            _hashCode += getSpatial().hashCode();
        }
        if (getSpectral() != null) {
            _hashCode += getSpectral().hashCode();
        }
        if (getTemporal() != null) {
            _hashCode += getTemporal().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Coverage.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Coverage"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("spatial");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "spatial"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spatial"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("spectral");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "spectral"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spectral"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("temporal");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "temporal"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Temporal"));
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
