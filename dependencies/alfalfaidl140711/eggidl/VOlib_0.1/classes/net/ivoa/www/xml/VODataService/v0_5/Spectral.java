/**
 * Spectral.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VODataService.v0_5;

public class Spectral  implements java.io.Serializable {
    private net.ivoa.www.xml.VODataService.v0_5.Waveband[] waveband;
    private net.ivoa.www.xml.VODataService.v0_5.WavelengthRange range;
    private java.lang.Float resolution;

    public Spectral() {
    }


    /**
     * Gets the waveband value for this Spectral.
     * 
     * @return waveband
     */
    public net.ivoa.www.xml.VODataService.v0_5.Waveband[] getWaveband() {
        return waveband;
    }


    /**
     * Sets the waveband value for this Spectral.
     * 
     * @param waveband
     */
    public void setWaveband(net.ivoa.www.xml.VODataService.v0_5.Waveband[] waveband) {
        this.waveband = waveband;
    }

    public net.ivoa.www.xml.VODataService.v0_5.Waveband getWaveband(int i) {
        return this.waveband[i];
    }

    public void setWaveband(int i, net.ivoa.www.xml.VODataService.v0_5.Waveband value) {
        this.waveband[i] = value;
    }


    /**
     * Gets the range value for this Spectral.
     * 
     * @return range
     */
    public net.ivoa.www.xml.VODataService.v0_5.WavelengthRange getRange() {
        return range;
    }


    /**
     * Sets the range value for this Spectral.
     * 
     * @param range
     */
    public void setRange(net.ivoa.www.xml.VODataService.v0_5.WavelengthRange range) {
        this.range = range;
    }


    /**
     * Gets the resolution value for this Spectral.
     * 
     * @return resolution
     */
    public java.lang.Float getResolution() {
        return resolution;
    }


    /**
     * Sets the resolution value for this Spectral.
     * 
     * @param resolution
     */
    public void setResolution(java.lang.Float resolution) {
        this.resolution = resolution;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Spectral)) return false;
        Spectral other = (Spectral) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.waveband==null && other.getWaveband()==null) || 
             (this.waveband!=null &&
              java.util.Arrays.equals(this.waveband, other.getWaveband()))) &&
            ((this.range==null && other.getRange()==null) || 
             (this.range!=null &&
              this.range.equals(other.getRange()))) &&
            ((this.resolution==null && other.getResolution()==null) || 
             (this.resolution!=null &&
              this.resolution.equals(other.getResolution())));
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
        if (getWaveband() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getWaveband());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getWaveband(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRange() != null) {
            _hashCode += getRange().hashCode();
        }
        if (getResolution() != null) {
            _hashCode += getResolution().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Spectral.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spectral"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("waveband");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "waveband"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Waveband"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("range");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "range"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "WavelengthRange"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resolution");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "resolution"));
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
